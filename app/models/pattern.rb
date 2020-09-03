class Pattern < ApplicationRecord
  belongs_to :user
  belongs_to :yarn

  before_save :normalize_stripes
  before_save :assign_slug

  def normalize_stripes
    # input: [{color: '2028', width: 3}]
    # output:
    #   stripes: [['a', 3]]
    #   default_colors: { a: '2028' }
    normalized = []
    mapping = {}
    current_color = 'a'
    self.stripes ||= []

    stripes.each do |stripe|
      next if stripe.is_a?(Array) # these stripes are already normalized, only do this if we get the hash-stripes
      if mapping[stripe["color"]].nil?
        mapping[stripe["color"]] = current_color
        current_color = current_color.next
      end
      normalized << [mapping[stripe["color"]], stripe["width"]]
    end

    self.stripes = normalized
    self.default_colors = mapping.invert
  end

  def scaled_stripes
    total_width = stripes.map(&:second).map(&:to_i).sum.to_f
    stripes.map do |color, width|
      [color, (width.to_i * 100 / total_width)]
    end
  end

  def assign_slug
    self.slug ||= SecureRandom.hex(12)
  end


  def has_breadcrumbs?
    vavstuga_product_url.present? && vavstuga_category_url.present? && category.present?
  end

  def category
    case name
    when /Towels? #\d+/
      "Towels"
    when /Blankets? #\d+/
      "Blankets"
    else
      ""
    end
  end

end
