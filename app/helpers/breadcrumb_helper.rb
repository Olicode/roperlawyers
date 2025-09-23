module BreadcrumbHelper
  def breadcrumb_for_page(service, location = nil, area = nil)
    breadcrumbs = []
    
    # Home
    breadcrumbs << { name: "Home", url: root_path }
    
    # Service level
    service_name = service_display_name(service)
    service_url = "/#{service.gsub('_', '-')}"
    breadcrumbs << { name: service_name, url: service_url }
    
    # Location level (Lanzarote)
    if location
      location_name = location_display_name(location)
      location_url = "#{service_url}/#{location.gsub('_', '-')}"
      breadcrumbs << { name: location_name, url: location_url }
    end
    
    # Area level (Puerto del Carmen, etc.)
    if area
      area_name = area_display_name(area)
      breadcrumbs << { name: area_name, url: nil } # Current page, no link
    end
    
    breadcrumbs
  end
  
  def render_breadcrumb(service, location = nil, area = nil)
    breadcrumbs = breadcrumb_for_page(service, location, area)
    
    # Generate BreadcrumbList schema markup
    schema_markup = generate_breadcrumb_schema(breadcrumbs)
    
    content_tag :section, class: "breadcrumb-section", style: "background-color: #f8f9fa; border-bottom: 1px solid #e9ecef; padding: 0.75rem 0;" do
      schema_markup +
      content_tag(:div, class: "container") do
        content_tag :nav, class: "breadcrumb-nav", "aria-label": "breadcrumb" do
          content_tag :ol, class: "breadcrumb mb-0" do
            breadcrumbs.map.with_index do |crumb, index|
              content_tag :li, class: "breadcrumb-item #{'active' if crumb[:url].nil?}" do
                if crumb[:url]
                  link_to crumb[:name], crumb[:url], class: "text-decoration-none", style: "color: #b29c84;"
                else
                  content_tag :span, crumb[:name], class: "text-muted"
                end
              end
            end.join.html_safe
          end
        end
      end
    end
  end
  
  def location_links_for_service(service, current_location = nil, current_area = nil)
    locations = [
      { name: "Puerto del Carmen", slug: "puerto-del-carmen" },
      { name: "Playa Blanca", slug: "playa-blanca" },
      { name: "Costa Teguise", slug: "costa-teguise" }
    ]
    
    base_url = "/#{service.gsub('_', '-')}/lanzarote"
    
    content_tag :div, class: "location-links mb-4 p-3 bg-light rounded" do
      content_tag(:h4, "#{service_display_name(service)} in Other Lanzarote Areas:", class: "h6 mb-3") +
      content_tag(:div, class: "d-flex flex-wrap gap-2") do
        locations.map do |location|
          unless current_area == location[:slug]
            link_to location[:name], "#{base_url}/#{location[:slug]}", 
                    class: "btn btn-outline-primary btn-sm", 
                    style: "color: #b29c84; border-color: #b29c84;"
          end
        end.compact.join.html_safe
      end
    end
  end
  
  def render_manual_breadcrumb(items)
    # Generate schema markup for manual breadcrumbs
    schema_markup = generate_breadcrumb_schema(items)
    
    content_tag :section, class: "breadcrumb-section", style: "background-color: #f8f9fa; border-bottom: 1px solid #e9ecef; padding: 0.75rem 0;" do
      schema_markup +
      content_tag(:div, class: "container") do
        content_tag :nav, "aria-label": "breadcrumb" do
          content_tag :ol, class: "breadcrumb mb-0" do
            items.map.with_index do |item, index|
              content_tag :li, class: "breadcrumb-item #{'active' if item[:url].nil?}" do
                if item[:url]
                  link_to item[:name], item[:url], class: "text-decoration-none", style: "color: #b29c84;"
                else
                  content_tag :span, item[:name], class: "text-muted", "aria-current": "page"
                end
              end
            end.join.html_safe
          end
        end
      end
    end
  end

  def generate_breadcrumb_schema(breadcrumbs)
    schema_items = breadcrumbs.map.with_index do |crumb, index|
      item = {
        "@type" => "ListItem",
        "position" => index + 1,
        "name" => crumb[:name]
      }
      
      if crumb[:url]
        item["item"] = "https://www.roperlawyers.com#{crumb[:url]}"
      end
      
      item
    end
    
    schema = {
      "@context" => "https://schema.org",
      "@type" => "BreadcrumbList",
      "itemListElement" => schema_items
    }
    
    content_tag :script, type: "application/ld+json" do
      schema.to_json.html_safe
    end
  end

  private
  
  def service_display_name(service)
    case service
    when 'buying_property', 'buying-property'
      'Buying Property'
    when 'selling_property', 'selling-property'
      'Selling Property'
    when 'wills'
      'Wills & Testament'
    when 'inheritance'
      'Inheritance Law'
    when 'new_build_registration', 'new-build-registration'
      'New Build Registration'
    when 'holiday_rental_license', 'holiday-rental-license'
      'Holiday Rental License'
    else
      service.humanize
    end
  end
  
  def location_display_name(location)
    case location
    when 'lanzarote'
      'Lanzarote'
    else
      location.humanize
    end
  end
  
  def area_display_name(area)
    case area
    when 'puerto_del_carmen', 'puerto-del-carmen'
      'Puerto del Carmen'
    when 'playa_blanca', 'playa-blanca'
      'Playa Blanca'
    when 'costa_teguise', 'costa-teguise'
      'Costa Teguise'
    else
      area.humanize
    end
  end
end
