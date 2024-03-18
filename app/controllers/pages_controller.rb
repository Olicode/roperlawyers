class PagesController < ApplicationController
  before_action :set_reviews, except: %i[contact_us]

  def lanzarote
    @mtitle = "Property Lawyers in Lanzarote - Property Conveyancing Solicitors"
    @mdescription = "Experienced property lawyers in Lanzarote are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def tenerife
    @mtitle = "Property Lawyers in Tenerife - Property Conveyancing Solicitors"
    @mdescription = "Experienced property lawyers in Tenerife are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
    @reviews = JSON.parse(File.read(File.join('public', 'tenerife_reviews.json')))
  end

  def grancanaria
    @mtitle = "Property Conveyancing Solicitors in Gran Canaria"
    @mdescription = "Experienced property lawyers in Gran Canaria are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
    @reviews = JSON.parse(File.read(File.join('public', 'grancanaria_reviews.json')))
  end
  def review_page
  end

  def fuerteventura
    @mtitle = "Property Conveyancing Solicitors in Fuerteventura"
    @mdescription = "Experienced property lawyers in Fuerteventura are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
   @reviews = JSON.parse(File.read(File.join('public', 'fuerteventura_reviews.json')))
  end

  def marbella
    @mtitle = "Property Lawyers in Marbella - Property Conveyancing Solicitors"
    @mdescription = "Experienced property lawyers in Marbella are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
    @reviews = JSON.parse(File.read(File.join('public', 'marbella_reviews.json')))
  end

  def mardrid
    @mtitle = "Property Conveyancing Solicitors in Madrid"
    @mdescription = "Experienced property lawyers in Madrid are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
    @reviews = JSON.parse(File.read(File.join('public', 'madrid_reviews.json')))
  end

  def ibizq
    @mtitle = "Property Lawyers in Ibiza - Property Conveyancing Solicitors"
    @mdescription = "Experienced property lawyers in Ibiza are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
    @reviews = JSON.parse(File.read(File.join('public', 'ibiza_reviews.json')))
  end



  def home
  end

  def contact_us
    TransactionalMailer.contact_us(ENV['MAILER_TO'] || "rcvdtest@yopmail.com", params[:email], params[:message]).deliver!
    render json: { success: true }
  end

  private

  def set_reviews
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end
end
