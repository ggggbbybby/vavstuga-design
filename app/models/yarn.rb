class Yarn < ApplicationRecord
  has_many :patterns

  def display_name
    "#{size} #{name}"
  end
end
