module ReviewsHelper
  GOOGLE_AVATAR_COLORS = %w[
    #DB4437 #4285F4 #0F9D58 #F4B400 #AB47BC #00ACC1 #FF7043 #9E9D24
  ].freeze

  def review_avatar_color(name)
    GOOGLE_AVATAR_COLORS[name.to_s.bytes.sum % GOOGLE_AVATAR_COLORS.size]
  end

  def review_initial(name)
    name.to_s.strip[0]&.upcase || "?"
  end
end
