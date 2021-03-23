class Yarn < ApplicationRecord
  has_many :patterns

  URL_PREFIX = "https://store.vavstuga.com/mm5/graphics/00000001/"
  def url
    URL_PREFIX + slug
  end

  def display_name
    "#{size} #{name}"
  end

  def color_options
    colors.map do |color|
      ["#{color['name'].titlecase} (##{color['code']})", color['code']]
    end
  end

  def color_names
    colors.each_with_object({}) do |color, memo|
      memo[color['code'].to_s] = color['name'].titlecase
    end
  end

  def self.to_options
    Yarn.all.map { |y| [y.display_name, y.id] }
  end

  def default_warp
    # use the color closest to white
    white_color_names = ['ivory', 'bleached']
    white = colors.detect { |color| color['name'].in?(white_color_names) }
    white && white['code']
  end

  def default_weft
    # use the color closest to red
    red_color_names = ['cardinal', 'dark cardinal']
    red = colors.detect { |color| color['name'].in?(red_color_names) }
    red && red['code']
  end

end
