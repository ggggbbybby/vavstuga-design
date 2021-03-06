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

    # if we're saving this from console or wherever, do not overwrite the existing ones.
    return if stripes.nil? || stripes.all? { |stripe| stripe.is_a?(Array) }

    normalized = []
    mapping = {}
    current_color = 'a'
    self.stripes ||= []

    stripes.each do |stripe|
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
    return vavstuga_category_name if vavstuga_category_name.present?

    # old hard-coded logic for towels and blankets
    case name
    when /Towels? #\d+/
      "Towels to go"
    when /Blankets? #\d+/
      "Blankets to go"
    else
      ""
    end
  end

  def product_name
    return vavstuga_product_name if vavstuga_product_name.present?

    # keep the old behavior
    case name
    when /(Towels?|Blankets?) #\d+/
      "#{name}, choose warp colors"
    else
      ""
    end
  end

  def self.duplicate!(pattern)
    pattern.dup.tap do |duped|
      duped.name = pattern.name + " (duplicate)"
      duped.slug = nil
      duped.save!
    end
  end

end
