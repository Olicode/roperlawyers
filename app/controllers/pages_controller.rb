class PagesController < ApplicationController
  before_action :set_page_data, except: %i[contact_us]

  def home; end
  def lanzarote; end
  def lanzarote_conveyancing_lawyer; end
  def puerto_del_carmen_property_conveyancing_lawyer; end
  def tenerife; end
  def grancanaria; end
  def fuerteventura; end
  def marbella; end
  def malaga; end
  def madrid; end
  def ibiza; end
  def costa_blanca; end
  def reviews; end
  def our_story; end
  def services; end
  def property_buying_guide; end
  def canary_islands_holiday_rental_laws; end
  def tourist_use_trap; end
  def blog; end
  def holiday_rental_license; end

  # Consolidated actions for matrix pages
  def buying_property_detail; end
  def selling_property_detail; end
  def wills_detail; end
  def inheritance_detail; end
  def new_build_registration_detail; end
  def holiday_rental_license_detail; end
  def buying_property_lanzarote; end
  def selling_property_lanzarote; end
  def wills_lanzarote; end
  def inheritance_lanzarote; end
  def new_build_registration_lanzarote; end
  def holiday_rental_license_lanzarote; end
  def buying_property_lanzarote_puerto_del_carmen; end
  def selling_property_lanzarote_puerto_del_carmen; end
  def wills_lanzarote_puerto_del_carmen; end
  def inheritance_lanzarote_puerto_del_carmen; end
  def new_build_registration_lanzarote_puerto_del_carmen; end
  def holiday_rental_license_lanzarote_puerto_del_carmen; end
  def buying_property_lanzarote_playa_blanca; end
  def selling_property_lanzarote_playa_blanca; end
  def wills_lanzarote_playa_blanca; end
  def inheritance_lanzarote_playa_blanca; end
  def new_build_registration_lanzarote_playa_blanca; end
  def holiday_rental_license_lanzarote_playa_blanca; end
  def buying_property_lanzarote_costa_teguise; end
  def selling_property_lanzarote_costa_teguise; end
  def wills_lanzarote_costa_teguise; end
  def inheritance_lanzarote_costa_teguise; end
  def new_build_registration_lanzarote_costa_teguise; end
  def holiday_rental_license_lanzarote_costa_teguise; end
  def thank_you; end
  def propertybase_success; end

  def step2_contact
    # Get parameters from Salesforce redirect (if any)
    @first_name = params[:first_name] || session[:contact_first_name]
    @last_name = params[:last_name] || session[:contact_last_name]
    @email = params[:email] || session[:contact_email]
    
    # Store in session for form pre-population
    session[:contact_first_name] = @first_name
    session[:contact_last_name] = @last_name
    session[:contact_email] = @email
  end

  def team; end
  def team_olivier_roper; end
  def team_rachel_jane_buckett; end
  def why_choose_us; end
  def spain_property_guide; end
  def free_consultation; end
  def consultation; end
  def vv_license; end
  def privacy_policy; end
  def cookies_policy; end
  def contact; end

  def contact_us
    TransactionalMailer.contact_us(ENV['MAILER_TO'] || "rcvdtest@yopmail.com", params[:email],params[:url], params[:message]).deliver!
    render json: { success: true }
  end

  private

  def set_page_data
    @page_metadata = YAML.load_file(Rails.root.join('config', 'page_metadata.yml'))
    
    # Use metadata_key param if present (for dynamic routes), otherwise action_name
    lookup_key = params[:metadata_key] || action_name
    @page_data = @page_metadata[lookup_key] || {}
    
    @mtitle = @page_data['title']
    @mdescription = @page_data['description']
    
    if @page_data['reviews'].present?
      reviews_path = Rails.root.join('public', @page_data['reviews'])
      @reviews = JSON.parse(File.read(reviews_path)) if File.exist?(reviews_path)
    end

    # Fallback to shared template for geographical expansion pages
    render 'service_location_shared' if @page_data['use_shared_template']
  end
end
