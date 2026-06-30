class SitemapsController < ApplicationController
  def index
    @base_url = request.base_url
    @routes = generate_sitemap_routes
    
    respond_to do |format|
      format.xml { render layout: false }
    end
  end

  private

  def generate_sitemap_routes
    routes = []
    
    # Manually define all the important routes for better control
    static_routes = [
      '/',
      '/lanzarote',
      '/lanzarote-conveyancing-lawyer',
      '/puerto-del-carmen-property-conveyancing-lawyer',
      '/tenerife',
      '/grancanaria',
      '/fuerteventura',
      '/marbella',
      '/malaga',
      '/madrid',
      '/ibiza',
      '/costa-blanca',
      '/spain-property-guide',
      '/free-consultation',
      '/consultation',
      '/reviews',
      '/our-story',
      '/team',
      '/team/olivier-roper',
      '/team/rachel-jane-buckett',
      '/why-choose-us',
      '/services',
      '/property-buying-guide',
      '/canary-islands-holiday-rental-laws',
      '/canary-islands-tourist-use-legal-trap',
      '/vv-license',
      '/blog',
      '/privacy-policy',
      '/cookies-policy',
      '/buying-property',
      '/buying-property/lanzarote',
      '/buying-property/lanzarote/puerto-del-carmen',
      '/buying-property/lanzarote/playa-blanca',
      '/buying-property/lanzarote/costa-teguise',
      '/buying-property/tenerife/adeje',
      '/buying-property/tenerife/los-cristianos',
      '/buying-property/tenerife/las-americas',
      '/buying-property/grancanaria/maspalomas',
      '/buying-property/grancanaria/meloneras',
      '/buying-property/grancanaria/las-palmas',
      '/selling-property',
      '/selling-property/lanzarote',
      '/selling-property/lanzarote/puerto-del-carmen',
      '/selling-property/lanzarote/playa-blanca',
      '/selling-property/lanzarote/costa-teguise',
      '/wills',
      '/wills/lanzarote',
      '/wills/lanzarote/puerto-del-carmen',
      '/wills/lanzarote/playa-blanca',
      '/wills/lanzarote/costa-teguise',
      '/inheritance',
      '/inheritance/lanzarote',
      '/inheritance/lanzarote/puerto-del-carmen',
      '/inheritance/lanzarote/playa-blanca',
      '/inheritance/lanzarote/costa-teguise',
      '/new-build-registration',
      '/new-build-registration/lanzarote',
      '/new-build-registration/lanzarote/puerto-del-carmen',
      '/new-build-registration/lanzarote/playa-blanca',
      '/new-build-registration/lanzarote/costa-teguise',
      '/holiday-rental-license',
      '/holiday-rental-license/lanzarote',
      '/holiday-rental-license/lanzarote/puerto-del-carmen',
      '/holiday-rental-license/lanzarote/playa-blanca',
      '/holiday-rental-license/lanzarote/costa-teguise',
      '/contact'
    ]
    
    # Convert to route objects with metadata
    static_routes.each do |path|
      routes << {
        url: path,
        lastmod: get_last_modified_date(path),
        changefreq: get_change_frequency(path),
        priority: get_priority(path)
      }
    end
    
    # Sort by priority (highest first)
    routes.sort_by { |route| -route[:priority].to_f }
  end

  def get_last_modified_date(path)
    # For dynamic content, use current date
    # In a real application, you might check file modification times or database timestamps
    #
    # Legal guide last-reviewed dates — update these when you revise the page content.
    case path
    when '/blog', '/reviews'
      Date.current # These might be updated frequently
    when '/canary-islands-holiday-rental-laws'
      Date.parse('2026-01-29') # Last reviewed: matches on-page "Last Updated" date
    when '/canary-islands-tourist-use-legal-trap'
      Date.parse('2026-03-04') # Last reviewed: Decree-Law 2/2025 / tourist-use trap guide
    when '/property-buying-guide'
      Date.parse('2025-09-21') # Last reviewed: expat property buying guide
    else
      Date.current - 30.days # Default to 30 days ago for static content
    end
  end

  def get_change_frequency(path)
    case path
    when '/', '/blog'
      'weekly'
    when '/reviews', '/contact'
      'monthly'
    when /canary-islands-holiday-rental-laws/, /canary-islands-tourist-use-legal-trap/, /property-buying-guide/
      'yearly'
    else
      'monthly'
    end
  end

  def get_priority(path)
    case path
    when '/'
      '1.0'
    when '/buying-property', '/selling-property', '/contact', '/free-consultation'
      '0.9'
    when '/services', '/wills', '/inheritance', '/holiday-rental-license'
      '0.8'
    when '/blog', '/reviews', '/our-story', '/team'
      '0.7'
    when /puerto-del-carmen/, /playa-blanca/, /costa-teguise/,
         /adeje/, /los-cristianos/, /las-americas/, /maspalomas/, /meloneras/, /las-palmas/
      '0.5'
    when /lanzarote$/, /tenerife/, /grancanaria/, /fuerteventura/, /marbella/
      '0.6'
    else
      '0.4'
    end
  end
end
