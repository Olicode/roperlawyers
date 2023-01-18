class PagesController < ApplicationController
  before_action :set_reviews, except: %i[contact_us]

  def lanzarote
    @reviews = JSON.parse(File.read(File.join('public', 'lanzarote_reviews.json')))
  end

  def tenerife
    @reviews = JSON.parse(File.read(File.join('public', 'tenerife_reviews.json')))
  end

  def tenerife
    @reviews = JSON.parse(File.read(File.join('public', 'grancanaria_reviews.json')))
  end
  def review_page
  end

  def fuerteventura
   @reviews = JSON.parse(File.read(File.join('public', 'fuerteventura_reviews.json')))
  end

  def marbella
    @reviews = JSON.parse(File.read(File.join('public', 'marbella_reviews.json')))
  end

  def home
  end

  def contact_us
    # TODO
    TransactionalMailer.contact_us('info@roperlawyers.com').deliver
    render json: { success: true }
  end

  private

  def set_reviews
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end
end
