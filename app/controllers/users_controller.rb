class UsersController < ApplicationController
  before_action :set_user, :authenticate_user!, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sf_contact_id = SalesforceService.create_contact(sf_attrs_map(@user))
        @user.update!(sf_contact_id: sf_contact_id)
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        if @user.sf_contact_id.blank?
          sf_contact_id = SalesforceService.create_contact(sf_attrs_map(@user))
          @user.update!(sf_contact_id: sf_contact_id)
        else
          SalesforceService.update_contact(sf_attrs_map(@user).merge!(Id: @user.sf_contact_id))

          if user_params[:nie_document].present?
            SalesforceService.upload_file(sf_file_upload_attrs_map(@user, user_params[:nie_document], "NIE"))
          end

          if user_params[:passport_document].present?
            SalesforceService.upload_file(sf_file_upload_attrs_map(@user, user_params[:passport_document], "Passport"))
          end
        end
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params
        .require(:user)
        .permit(
          :first_name, :last_name, :passport_number,
          :nie_number, :email, :sf_contact_id, :date_of_, :expiry_date,
          :mobile_phone, :here_till, :full_name_on_passport, :nationality,
          :profession, :marital_status, :spouse, :mailing_address,
          :father_s_first_name, :mother_s_first_name,
          :r_origin_bank_details, :otb_origin_bank_details,
          :balance_bank_details, :standing_orders_bank_details, :nie_document, :passport_document, :needs_poa,
          :name_of_the_present_spouse__c, :name_of_the_previous_spouses__c, :date_of_divorce, :date_of_decease,
          :tax_resident, :father_s_full_name, :father_s_vital_status, :mother_s_full_name, :mother_s_vital_status,
          :children,
          :outline_of_bequests_and_oder_of_success, :inheritance_to_be_governed_by
        )
    end
end
