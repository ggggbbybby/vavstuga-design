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
end
