module SchemaHelper
  def structured_data
    schema = {
      "@context": "https://schema.org",
      "@type": "LegalService",
      "name": "Roper Lawyers",
      "description": @mdescription || "Expert Spanish property lawyers with 15+ years' experience.",
      "url": request.original_url,
      "telephone": "+34928974241",
      "email": "info@roperlawyers.com",
      "address": {
        "@type": "PostalAddress",
        "streetAddress": "C. Acatife, 9",
        "addressLocality": "Puerto del Carmen",
        "addressRegion": "Las Palmas",
        "postalCode": "35510",
        "addressCountry": "ES"
      },
      "openingHours": "Mo-Fr 09:00-17:00",
      "image": image_url("roperlawyerslogo.png"),
      "priceRange": "$$"
    }


    content_tag(:script, schema.to_json.html_safe, type: "application/ld+json")
  end

  def video_schema(video_data)
    schema = {
      "@context": "https://schema.org",
      "@type": "VideoObject",
      "name": video_data[:name],
      "description": video_data[:description],
      "thumbnailUrl": video_data[:thumbnail_url],
      "uploadDate": video_data[:upload_date],
      "duration": video_data[:duration],
      "contentUrl": video_data[:content_url],
      "embedUrl": video_data[:embed_url],
      "interactionStatistic": {
        "@type": "InteractionCounter",
        "interactionType": { "@type": "WatchAction" },
        "userInteractionCount": video_data[:views] || 1000
      }
    }

    content_tag(:script, schema.to_json.html_safe, type: "application/ld+json")
  end
end
