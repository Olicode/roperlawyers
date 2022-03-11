class PagesController < ApplicationController
  def lanzarote
  end

  def tenerife
  end

  def review_page
  end

  def fuerteventura
  end

  def home
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end

  def contact_us
    # TODO
    TransactionalMailer.contact_us('info@roperlawyers.com').deliver
    render json: { success: true }
  end
end
