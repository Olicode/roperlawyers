module SchemaHelper
  FIRM = {
    "@type": "LegalService",
    "name": "Roper Lawyers",
    "description": "Expert Spanish property lawyers with 15+ years' experience.",
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
    "priceRange": "€€"
  }.freeze

  # Source: Google Business Profile. Update manually when GBP totals change. Maps badge rounds to 5.0; true average is 4.9.
  GBP_REVIEW_COUNT = 94
  GBP_RATING_VALUE = 4.9

  def structured_data
    schema = FIRM.merge(
      "@context": "https://schema.org",
      "@id": "https://www.roperlawyers.com/#organization",
      "founder": { "@id": "https://www.roperlawyers.com/team/olivier-roper#person" },
      "description": @mdescription || FIRM[:description],
      "url": request.original_url,
      "image": image_url("roperlawyerslogo.png")
    )

    records = @reviews&.dig("records")
    if records.present?
      aggregate = aggregate_rating_node(records)
      schema[:aggregateRating] = aggregate if aggregate

      reviews = review_nodes(records)
      schema[:review] = reviews if reviews.present?
    end

    content_tag(:script, json_escape(schema.to_json).html_safe, type: "application/ld+json")
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

    content_tag(:script, json_escape(schema.to_json).html_safe, type: "application/ld+json")
  end

  private

  def aggregate_rating_node(records)
    return nil if records.blank?

    if GBP_REVIEW_COUNT.nil? || GBP_RATING_VALUE.nil?
      count = records.size
      rating_value = (records.sum { |r| r["rating"].to_f } / count).round(1)
    else
      count = GBP_REVIEW_COUNT
      rating_value = GBP_RATING_VALUE
    end

    {
      "@type": "AggregateRating",
      "ratingValue": rating_value,
      "reviewCount": count,
      "bestRating": 5,
      "worstRating": 1
    }
  end

  def review_nodes(records)
    return [] if records.blank?

    records
      .sort_by { |r| [r["featured"] == true ? 0 : 1, r["id"].to_i] }
      .first(10)
      .map do |review|
        {
          "@type": "Review",
          "author": {
            "@type": "Person",
            "name": review["name"]
          },
          "reviewRating": {
            "@type": "Rating",
            "ratingValue": review["rating"],
            "bestRating": 5,
            "worstRating": 1
          },
          "reviewBody": review["comment"].to_s.truncate(500)
        }
      end
  end
end
