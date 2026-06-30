module BreadcrumbHelper
  SERVICE_SLUGS = %w[
    buying-property
    selling-property
    wills
    inheritance
    new-build-registration
    holiday-rental-license
  ].freeze

  LOCATION_SLUGS = %w[
    lanzarote
    tenerife
    grancanaria
    fuerteventura
    marbella
    malaga
    madrid
    ibiza
    costa-blanca
  ].freeze

  AREA_SLUGS = %w[
    puerto-del-carmen
    playa-blanca
    costa-teguise
    adeje
    los-cristianos
    las-americas
    maspalomas
    meloneras
    las-palmas
    olivier-roper
    rachel-jane-buckett
  ].freeze

  PAGE_SLUG_OVERRIDES = {
    'lanzarote-conveyancing-lawyer' => 'Lanzarote Conveyancing Lawyer',
    'puerto-del-carmen-property-conveyancing-lawyer' => 'Puerto del Carmen Property Conveyancing Lawyer',
    'canary-islands-holiday-rental-laws' => 'Canary Islands Holiday Rental Laws',
    'canary-islands-tourist-use-legal-trap' => 'Canary Islands Tourist Use Legal Trap',
    'property-buying-guide' => 'Property Buying Guide',
    'free-consultation' => 'Free Consultation',
    'our-story' => 'Our Story',
    'why-choose-us' => 'Why Choose Us',
    'spain-property-guide' => 'Spain Property Guide',
    'vv-license' => 'VV License',
    'privacy-policy' => 'Privacy Policy',
    'cookies-policy' => 'Cookies Policy'
  }.freeze

  def breadcrumbs_from_path(path = request.path)
    clean_path = path.to_s.chomp('/')
    clean_path = '/' if clean_path.blank?
    return [] if clean_path == '/'

    segments = clean_path.delete_prefix('/').split('/')
    breadcrumbs = [{ name: 'Home', url: '/' }]

    segments.each_with_index do |segment, index|
      cumulative_path = "/#{segments.first(index + 1).join('/')}"
      is_current = index == segments.length - 1
      url = if is_current
              nil
            elsif breadcrumb_route_exists?(cumulative_path)
              cumulative_path
            end

      breadcrumbs << {
        name: breadcrumb_slug_name(segment),
        url: url
      }
    end

    breadcrumbs
  end

  def breadcrumb_for_page(service, location = nil, area = nil)
    breadcrumbs = []

    breadcrumbs << { name: 'Home', url: '/' }

    service_name = service_display_name(service)
    service_url = "/#{service.to_s.tr('_', '-')}"
    breadcrumbs << { name: service_name, url: service_url }

    if location
      location_name = location_display_name(location)
      location_url = "#{service_url}/#{location.to_s.tr('_', '-')}"
      breadcrumbs << { name: location_name, url: location_url }
    end

    if area
      area_name = area_display_name(area)
      breadcrumbs << { name: area_name, url: nil }
    end

    breadcrumbs
  end

  def render_breadcrumb(service, location = nil, area = nil)
    render_breadcrumb_section(breadcrumb_for_page(service, location, area))
  end

  def render_manual_breadcrumb(items)
    render_breadcrumb_section(items)
  end

  def render_breadcrumb_section(breadcrumbs)
    content_tag :section, class: 'breadcrumb-section', style: 'background-color: #f8f9fa; border-bottom: 1px solid #e9ecef; padding: 0.75rem 0;' do
      breadcrumb_schema_script(breadcrumbs) +
        content_tag(:div, class: 'container') do
          breadcrumb_nav(breadcrumbs)
        end
    end
  end

  def breadcrumb_nav(breadcrumbs)
    content_tag :nav, 'aria-label': 'breadcrumb' do
      content_tag :ol, class: 'breadcrumb mb-0' do
        breadcrumbs.each_with_index.map do |crumb, index|
          is_current = index == breadcrumbs.length - 1
          content_tag :li, class: "breadcrumb-item #{'active' if is_current}" do
            if crumb[:url]
              link_to crumb[:name], crumb[:url], class: 'text-decoration-none', style: 'color: #b29c84;'
            else
              content_tag :span, crumb[:name], class: 'text-muted', **(is_current ? { 'aria-current': 'page' } : {})
            end
          end
        end.join.html_safe
      end
    end
  end

  def breadcrumb_list_schema(breadcrumbs)
    {
      '@context' => 'https://schema.org',
      '@type' => 'BreadcrumbList',
      'itemListElement' => breadcrumbs.map.with_index do |crumb, index|
        item = {
          '@type' => 'ListItem',
          'position' => index + 1,
          'name' => crumb[:name]
        }
        item['item'] = "#{breadcrumb_site_url}#{crumb[:url]}" if crumb[:url]
        item
      end
    }
  end

  def breadcrumb_schema_script(breadcrumbs)
    content_tag(:script, json_escape(breadcrumb_list_schema(breadcrumbs).to_json).html_safe, type: 'application/ld+json')
  end

  def generate_breadcrumb_schema(breadcrumbs)
    breadcrumb_schema_script(breadcrumbs)
  end

  def location_links_for_service(service, current_island = nil, current_area = nil)
    current_island ||= @page_data&.[]('island')&.downcase&.gsub(' ', '')

    island_hotspots = {
      'lanzarote' => [
        { name: 'Puerto del Carmen', slug: 'puerto-del-carmen' },
        { name: 'Playa Blanca', slug: 'playa-blanca' },
        { name: 'Costa Teguise', slug: 'costa-teguise' }
      ],
      'tenerife' => [
        { name: 'Adeje', slug: 'adeje' },
        { name: 'Los Cristianos', slug: 'los-cristianos' },
        { name: 'Las Américas', slug: 'las-americas' }
      ],
      'grancanaria' => [
        { name: 'Maspalomas', slug: 'maspalomas' },
        { name: 'Meloneras', slug: 'meloneras' },
        { name: 'Las Palmas', slug: 'las-palmas' }
      ]
    }

    if current_island && island_hotspots[current_island]
      links = island_hotspots[current_island].map do |loc|
        next if current_area == loc[:slug]

        url = "/#{service.to_s.tr('_', '-')}/#{current_island}/#{loc[:slug]}"
        link_to loc[:name], url, class: 'btn btn-outline-primary btn-sm', style: 'color: #b29c84; border-color: #b29c84;'
      end.compact

      title = "Other #{current_island.titleize} Areas for #{service_display_name(service)}:"
    else
      links = [
        { name: 'Lanzarote', url: "/#{service.to_s.tr('_', '-')}/lanzarote" },
        { name: 'Tenerife', url: "/#{service.to_s.tr('_', '-')}/tenerife" },
        { name: 'Gran Canaria', url: "/#{service.to_s.tr('_', '-')}/grancanaria" },
        { name: 'Marbella', url: '/marbella' }
      ].map do |loc|
        link_to loc[:name], loc[:url], class: 'btn btn-outline-primary btn-sm', style: 'color: #b29c84; border-color: #b29c84;'
      end
      title = "Explore #{service_display_name(service)} by Location:"
    end

    content_tag :div, class: 'location-links mb-4 p-3 bg-light rounded' do
      content_tag(:h4, title, class: 'h6 mb-3') +
        content_tag(:div, class: 'd-flex flex-wrap gap-2') do
          links.join.html_safe
        end
    end
  end

  private

  def breadcrumb_route_exists?(path)
    Rails.application.routes.recognize_path(path, method: :get)
    true
  rescue ActionController::RoutingError
    false
  end

  def breadcrumb_site_url
    @breadcrumb_site_url ||= request.base_url.presence || 'https://www.roperlawyers.com'
  end

  def breadcrumb_slug_name(slug)
    return PAGE_SLUG_OVERRIDES[slug] if PAGE_SLUG_OVERRIDES.key?(slug)
    return service_display_name(slug) if SERVICE_SLUGS.include?(slug)
    return location_display_name(slug.tr('-', '_')) if LOCATION_SLUGS.include?(slug)
    return area_display_name(slug) if AREA_SLUGS.include?(slug)

    titleize_slug(slug)
  end

  def titleize_slug(slug)
    slug.split('-').map(&:capitalize).join(' ')
  end

  def service_display_name(service)
    case service.to_s.tr('_', '-')
    when 'buying-property'
      'Buying Property'
    when 'selling-property'
      'Selling Property'
    when 'wills'
      'Wills & Testament'
    when 'inheritance'
      'Inheritance Law'
    when 'new-build-registration'
      'New Build Registration'
    when 'holiday-rental-license'
      'Holiday Rental License'
    else
      service.to_s.tr('_', ' ').split.map(&:capitalize).join(' ')
    end
  end

  def location_display_name(location)
    case location.to_s.tr('-', '_')
    when 'lanzarote'
      'Lanzarote'
    when 'tenerife'
      'Tenerife'
    when 'grancanaria'
      'Gran Canaria'
    when 'fuerteventura'
      'Fuerteventura'
    when 'marbella'
      'Marbella'
    when 'malaga'
      'Malaga'
    when 'madrid'
      'Madrid'
    when 'ibiza'
      'Ibiza'
    when 'costa_blanca'
      'Costa Blanca'
    else
      titleize_slug(location.to_s.tr('_', '-'))
    end
  end

  def area_display_name(area)
    case area.to_s.tr('_', '-')
    when 'puerto-del-carmen'
      'Puerto del Carmen'
    when 'playa-blanca'
      'Playa Blanca'
    when 'costa-teguise'
      'Costa Teguise'
    when 'adeje'
      'Adeje'
    when 'los-cristianos'
      'Los Cristianos'
    when 'las-americas'
      'Las Américas'
    when 'maspalomas'
      'Maspalomas'
    when 'meloneras'
      'Meloneras'
    when 'las-palmas'
      'Las Palmas'
    when 'olivier-roper'
      'Olivier Roper'
    when 'rachel-jane-buckett'
      'Rachel Buckett'
    else
      titleize_slug(area.to_s.tr('_', '-'))
    end
  end
end
