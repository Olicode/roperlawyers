class sController < ApplicationController
  before_action :set_, only: %i[ show edit update destroy ]

  # GET /s or /s.json
  def index
    @s = .all
  end

  # GET /s/1 or /s/1.json
  def show
  end

  # GET /s/new
  def new
    @ = .new
  end

  # GET /s/1/edit
  def edit
  end

  # POST /s or /s.json
  def create
    @ = .new(_params)

    respond_to do |format|
      if @.save
        sf_contact_id = SalesforceService.create_contact(sf_attrs_map(@))
        @.update!(sf_contact_id: sf_contact_id)
        format.html { redirect_to _url(@), notice: " was successfully created." }
        format.json { render :show, status: :created, location: @ }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /s/1 or /s/1.json
  def update
    respond_to do |format|
      if @.update(_params)
        if @.sf_contact_id.blank?
          sf_contact_id = SalesforceService.create_contact(sf_attrs_map(@))
          @.update!(sf_contact_id: sf_contact_id)
        else
          SalesforceService.update_contact(sf_attrs_map(@).merge!(Id: @.sf_contact_id))

          if _params[:nie_document].present?
            SalesforceService.upload_file(sf_file_upload_attrs_map(@, _params[:nie_document], "NIE"))
          end

          if _params[:passport_document].present?
            SalesforceService.upload_file(sf_file_upload_attrs_map(@, _params[:passport_document], "Passport"))
          end
        end
        format.html { redirect_to _url(@), notice: " was successfully updated." }
        format.json { render :show, status: :ok, location: @ }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /s/1 or /s/1.json
  def destroy
    @.destroy

    respond_to do |format|
      format.html { redirect_to s_url, notice: " was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_
      @ = .find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def _params
      params
        .require(:)
        .permit(
          :first_name, :last_name, :passport_number,
          :nie_number, :email, :sf_contact_id, :date_of_birth, :expiry_date,
          :mobile_phone, :here_till, :full_name_on_passport, :nationality,
          :profession, :marital_status, :spouse, :mailing_address,
          :father_s_first_name, :mother_s_first_name,
          :r_origin_bank_details, :otb_origin_bank_details,
          :balance_bank_details, :standing_orders_bank_details, :nie_document, :passport_document, :needs_poa,
          :name_of_the_present_spouse__c, :name_of_the_previous_spouses__c, :date_of_divorce, :date_of_decease
        )
    end
end
