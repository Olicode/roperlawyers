class PagesController < ApplicationController
  def lanzarote
  end

  def tenerife
  end

  def review_page
  end

  def home
    @reviews = JSON.parse(File.read(File.join('public','reviews.json')))
  end
end
