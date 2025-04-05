class PagesController < ApplicationController
  before_action :set_reviews, except: %i[contact_us]

  def lanzarote
    @mtitle = "Property solicitors Lanzarote, find Lanzarote property lawyers"
    @mdescription = "If you’re looking for English-speaking real estate lawyers in Lanzarote, look no further. Contact our property lawyers for legal advice now."
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def tenerife
    @mtitle = "Tenerife estate agents, find property lawyers in Tenerife"
    @mdescription = "If you need advice for buying a property in Tenerife or you’re looking to sell your property in Spain, contact our team. We can guide you through the process today."
    @reviews = JSON.parse(File.read(File.join('public', 'tenerife_reviews.json')))
  end

  def grancanaria
    @mtitle = "Property lawyers Gran Canaria, find Gran Canaria estate agents"
    @mdescription = "Looking to buy or sell a property in Gran Canaria? Our property lawyers and estate agents in Gran Canaria can guide you through the process. Call today."
    @reviews = JSON.parse(File.read(File.join('public', 'grancanaria_reviews.json')))
  end
  def review_page
  end

  def fuerteventura
    @mtitle = "Property lawyers Fuerteventura, find Fuerteventura estate agents"
    @mdescription = "Fuerteventura is a popular destination to buy, sell, and invest in property. If you need property lawyers in Fuerteventura, call us today."
   @reviews = JSON.parse(File.read(File.join('public', 'fuerteventura_reviews.json')))
  end

  def marbella
    @mtitle = "Property solicitors in Marbella, find Marbella property lawyers"
    @mdescription = "Roper Lawyers are your trusted English-speaking real estate lawyers in Marbella. Find property lawyers providing secure and tailored legal advice now."
    @reviews = JSON.parse(File.read(File.join('public', 'marbella_reviews.json')))
  end

  def mardrid
    @mtitle = "Property Conveyancing Solicitors in Madrid"
    @mdescription = "Experienced property lawyers in Madrid are ready to help. Buying or selling a property in Spain and need a solicitor? Enquire, here."
    @reviews = JSON.parse(File.read(File.join('public', 'madrid_reviews.json')))
  end

  def ibizq
    @mtitle = "Property lawyers Ibiza, find property solicitors in Ibiza"
    @mdescription = "Find your dream home in Spain through our property solicitors in Ibiza. Experience expert legal advice from our English-speaking lawyers today."
    @reviews = JSON.parse(File.read(File.join('public', 'ibiza_reviews.json')))
  end



  def home
  end

  def contact_us
    TransactionalMailer.contact_us(ENV['MAILER_TO'] || "rcvdtest@yopmail.com", params[:email],params[:url], params[:message]).deliver!
    render json: { success: true }
  end

  private

  def set_reviews
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end


  def free_consultation
    # Static page; no logic is required here.
  end

  def consultation
  end
  
end

