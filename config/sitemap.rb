# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.roperlawyers.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  # Static Pages (from routes.rb)
  add '/lanzarote', priority: 0.8, changefreq: 'monthly'
  add '/lanzarote-conveyancing-lawyer', priority: 0.8, changefreq: 'monthly'
  add '/puerto_del_carmen_property_conveyancing_lawyer', priority: 0.8, changefreq: 'monthly'
  add '/tenerife', priority: 0.8, changefreq: 'monthly'
  add '/grancanaria', priority: 0.8, changefreq: 'monthly'
  add '/fuerteventura', priority: 0.8, changefreq: 'monthly'
  add '/marbella', priority: 0.8, changefreq: 'monthly'
  add '/madrid', priority: 0.8, changefreq: 'monthly'
  add '/ibiza', priority: 0.8, changefreq: 'monthly'
  
  add '/spain-property-guide', priority: 0.7, changefreq: 'monthly'
  add '/free-consultation', priority: 0.9, changefreq: 'monthly'
  add '/reviews', priority: 0.7, changefreq: 'weekly'
  add '/our-story', priority: 0.6, changefreq: 'monthly'
  add '/team', priority: 0.6, changefreq: 'monthly'
  add '/why-choose-us', priority: 0.6, changefreq: 'monthly'
  
  add '/services', priority: 0.8, changefreq: 'monthly'
  add '/property-buying-guide', priority: 0.7, changefreq: 'monthly'
  add '/canary-islands-holiday-rental-laws', priority: 0.7, changefreq: 'yearly'
  add '/vv-license', priority: 0.8, changefreq: 'monthly'
  add '/blog', priority: 0.7, changefreq: 'weekly'
  
  add '/buying-property', priority: 0.9, changefreq: 'monthly'
  add '/selling-property', priority: 0.9, changefreq: 'monthly'
  add '/wills', priority: 0.8, changefreq: 'monthly'
  add '/inheritance', priority: 0.8, changefreq: 'monthly'
  add '/new-build-registration', priority: 0.8, changefreq: 'monthly'
  add '/holiday-rental-license', priority: 0.8, changefreq: 'monthly'

  # Location specific nested pages
  ['buying-property', 'selling-property', 'wills', 'inheritance', 'new-build-registration', 'holiday_rental_license'].each do |service|
    add "/#{service}/lanzarote", priority: 0.7
    ['puerto-del-carmen', 'playa-blanca', 'costa-teguise'].each do |location|
      add "/#{service}/lanzarote/#{location}", priority: 0.6
    end
  end

  add '/contact', priority: 0.9, changefreq: 'monthly'
end
