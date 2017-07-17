class Yarn < ApplicationRecord
  has_many :patterns

  def display_name
    "#{size} #{name}"
  end

  def color_options
    colors.map do |color|
      ["#{color['name'].titlecase} (##{color['code']})", color['code']]
    end
  end
end
