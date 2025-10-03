class UsersController < ApplicationController
  include SalesforceSyncHelpers
  before_action :set_user, :authenticate_user!, only: %i[ show edit update destroy ]
  layout "users"

  # GET /users or /users.json
  def index
    redirect_to root_path
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
    if @user.sf_contact_id.present?
      begin
        sf_contact = SalesforceService.find_contact(@user.sf_contact_id)
      rescue => e
        ErrorNotifier.call(message: "Error finding Salesforce contact: #{e.message}")
        sf_contact = nil
      end

      if sf_contact.present?
        @user.assign_attributes(SalesforceAdapter.adapt_from(sf_contact))
        @user.save!(validate: false)
      end
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # Salesforce sync is now handled by model callbacks

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
        # Salesforce sync is now handled by model callbacks

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
          :nie_number, :email, :sf_contact_id, :date_of_birth, :expiry_date,
          :mobile_phone, :here_till, :full_name_on_passport, :nationality,
          :profession, :marital_status, :spouse, :buying_property_address, :selling_property_address,
          :father_s_first_name, :mother_s_first_name,
          :r_origin_bank_details, :otb_origin_bank_details,
          :balance_bank_details, :standing_orders_bank_details, :nie_document, :passport_document, :needs_poa,
          :name_of_the_present_spouse, :name_of_the_previous_spouses, :date_of_divorce, :date_of_decease,
          :tax_resident, :father_s_full_name, :father_s_vital_status, :mother_s_full_name, :mother_s_vital_status,
          :children,
          :outline_of_bequests_and_oder_of_success, :inheritance_to_be_governed_by,
          :poa_made_in_spain, :poa_for, :needs_nie, :home_address, :currency, :needs_mortgage, :wants_to_holiday_let,
          :has_a_spanish_bank_account, :date_of_birth, :place_of_birth, :igic_registration_modelo_400_document, :energy_efficiency_certificate_cee,
          :escritura,
          :fx_quote_referral_consent,
          { requested_services: [] },
          nota_simple_documents: [], 
          title_deed_documents: [], 
          vv_license_documents: [], 
          first_occupation_license_documents: [], 
          cee_documents: [], 
          civil_liability_insurance_policy_documents: [],
          habitability_certificate_documents: [],
          municipal_certificate_documents: [],
          property_tax_receipt_documents: [],
          floor_plan_documents: [],
          community_approval_documents: [],
          water_bill_documents: [],
          electricity_bill_documents: []
        )
    end
end
