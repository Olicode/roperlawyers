class UsersController < ApplicationController
  before_action :set_user, :authenticate_user!, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.where(id: current_user.id)
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
      @sf_contact = SalesforceService.find_contact(@user.sf_contact_id)
      @user.update!(
        first_name: @sf_contact.FirstName,
        last_name: @sf_contact.LastName,
        email: @sf_contact.Email,
        mobile_phone: @sf_contact.MobilePhone,
        full_name_on_passport: @sf_contact.Full_name_on_passport__c,
        passport_number: @sf_contact.Passport_Number__c,
        date_of_birth: @sf_contact.Date_of_Birth__c,
        nationality: @sf_contact.Nationality__c,
        profession: @sf_contact.Profesi_n__c,
        marital_status: @sf_contact.Estado_Civil__c,
        spouse: @sf_contact.Spouse__c,
        home_address: @sf_contact.Home_Address_del__c,
        currency: @sf_contact.Currency__c,
        here_till: @sf_contact.Here_till__c,
        needs_mortgage: @sf_contact.Needs_Mortgage__c,
        wants_to_holiday_let: @sf_contact.Wants_to_holiday_let__c,
        tax_resident: @sf_contact.Tax_Resident__c || false,
        needs_poa: @sf_contact.Needs_PoA__c,
        poa_for: @sf_contact.PoA_for__c,
        poa_made_in_spain: @sf_contact.PoA_made_in_Spain__c,
        needs_nie: @sf_contact.Needs_NIE__c,
        nie_number: @sf_contact.NIE_Number__c,
        father_s_first_name: @sf_contact.Father_s_First_Name__c,
        mother_s_first_name: @sf_contact.Mother_s_First_Name__c,
        r_origin_bank_details: @sf_contact.R_origin_Bank_details__c,
        otb_origin_bank_details: @sf_contact.OTB_origin_Bank_details__c,
        balance_bank_details: @sf_contact.Balance_Bank_details__c,
        has_a_spanish_bank_account: @sf_contact.Has_a_Spanish_Bank_Account__c,
        standing_orders_bank_details: @sf_contact.Standing_orders_Bank_details__c,
        name_of_the_present_spouse: @sf_contact.Name_of_the_present_spouse__c,
        name_of_the_previous_spouses: @sf_contact.Name_of_the_previous_spouses__c,
        date_of_divorce: @sf_contact.Date_of_divorce__c,
        date_of_decease: @sf_contact.Date_of_decease__c,
        father_s_full_name: @sf_contact.Father_s_Full_Name__c,
        father_s_vital_status: @sf_contact.Father_s_Vital_Status__c,
        mother_s_full_name: @sf_contact.Mother_s_Full_Name__c,
        mother_s_vital_status: @sf_contact.Mother_s_Vital_Status__c,
        children: @sf_contact.Children__c,
        outline_of_bequests_and_oder_of_success: @sf_contact.Outline_of_bequests_and_order_of_success__c,
        inheritance_to_be_governed_by: @sf_contact.Inheritance_to_be_governed_by__c
      )
    end
  end

  # PoA_made_in_Spain__c
  # PoA_for__c

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sf_contact_id = SalesforceService.create_or_update_contact(sf_attrs_map(@user))
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
        # binding.pry
        if @user.sf_contact_id.blank?
          sf_contact_id = SalesforceService.create_or_update_contact(sf_attrs_map(@user))
          @user.update!(sf_contact_id: sf_contact_id) unless sf_contact_id == false
        else
          SalesforceService.update_contact(sf_attrs_map(@user).merge!(Id: @user.sf_contact_id))

          if user_params[:nie_document].present?
            SalesforceService.upload_file(sf_file_upload_attrs_map(@user, user_params[:nie_document], "NIE"))
          end

          if user_params[:passport_document].present?
            SalesforceService.upload_file(sf_file_upload_attrs_map(@user, user_params[:passport_document], "Passport"))
          end
          
          if user_params[:nota_simple_documents].present?
            user_params[:nota_simple_documents].each do |document|
              SalesforceService.upload_file(sf_file_upload_attrs_map(@user, document, "Nota Simple"))
            end
          end
          
          if user_params[:title_deed_documents].present?
            user_params[:title_deed_documents].each do |document|
              SalesforceService.upload_file(sf_file_upload_attrs_map(@user, document, "Title Deed"))
            end
          end
          
          if user_params[:vv_license_documents].present?
            user_params[:vv_license_documents].each do |document|
              SalesforceService.upload_file(sf_file_upload_attrs_map(@user, document, "VV License"))
            end
          end
          
          if user_params[:first_occupation_license_documents].present?
            user_params[:first_occupation_license_documents].each do |document|
              SalesforceService.upload_file(sf_file_upload_attrs_map(@user, document, "First Occupation License"))
            end
          end
          
          if user_params[:cee_documents].present?
            user_params[:cee_documents].each do |document|
              SalesforceService.upload_file(sf_file_upload_attrs_map(@user, document, "CEE"))
            end
          end
          
          if user_params[:civil_liability_insurance_policy_documents].present?
            user_params[:civil_liability_insurance_policy_documents].each do |document|
              SalesforceService.upload_file(sf_file_upload_attrs_map(@user, document, "Civil Liability Insurance Policy"))
            end
          end
          
          if user_params[:igic_registration_modelo_400_document].present?
            SalesforceService.upload_file(sf_file_upload_attrs_map(@user, user_params[:igic_registration_modelo_400_document], "IGIC Registration Modelo 400"))
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
          :name_of_the_present_spouse, :name_of_the_previous_spouses, :date_of_divorce, :date_of_decease,
          :tax_resident, :father_s_full_name, :father_s_vital_status, :mother_s_full_name, :mother_s_vital_status,
          :children,
          :outline_of_bequests_and_oder_of_success, :inheritance_to_be_governed_by,
          :poa_made_in_spain, :poa_for, :needs_nie, :home_address, :currency, :needs_mortgage, :wants_to_holiday_let,
          :has_a_spanish_bank_account, :date_of_birth, :igic_registration_modelo_400_document,
          nota_simple_documents: [], 
          title_deed_documents: [], 
          vv_license_documents: [], 
          first_occupation_license_documents: [], 
          cee_documents: [], 
          civil_liability_insurance_policy_documents: []
        )
    end
end
