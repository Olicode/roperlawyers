module SeoHelper
  def seo_tags
    title = content_for(:title) || @mtitle || "Spanish Property Lawyers | Expert Legal Services | Roper Lawyers"
    description = content_for(:description) || @mdescription || "Expert Spanish property lawyers with 15+ years' experience. Bilingual legal services for UK, Irish & international clients. Conveyancing, wills, inheritance & VV licenses."
    og_type = content_for(:og_type).presence || "website"
    og_image = content_for(:og_image).presence || image_url("roperlawyerslogo.png")
    
    tags = [
      content_tag(:title, title),
      tag(:meta, name: "description", content: description),
      tag(:link, rel: "canonical", href: request.original_url.split('?').first),
      
      # International signals
      tag(:link, rel: "alternate", hreflang: "en-ES", href: request.original_url.split('?').first),
      tag(:link, rel: "alternate", hreflang: "en-GB", href: request.original_url.split('?').first),
      tag(:link, rel: "alternate", hreflang: "en-IE", href: request.original_url.split('?').first),
      tag(:link, rel: "alternate", hreflang: "x-default", href: request.original_url.split('?').first),
      
      # Open Graph
      tag(:meta, property: "og:site_name", content: "Roper Lawyers"),
      tag(:meta, property: "og:title", content: title),
      tag(:meta, property: "og:description", content: description),
      tag(:meta, property: "og:type", content: og_type),
      tag(:meta, property: "og:url", content: request.original_url),
      tag(:meta, property: "og:image", content: og_image),
      
      # Twitter
      tag(:meta, name: "twitter:card", content: "summary_large_image"),
      tag(:meta, name: "twitter:title", content: title),
      tag(:meta, name: "twitter:description", content: description),
      tag(:meta, name: "twitter:image", content: og_image)
    ]
    
    safe_join(tags, "\n").html_safe
  end
end
