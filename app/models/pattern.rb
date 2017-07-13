class Pattern < ApplicationRecord
  belongs_to :user
  belongs_to :yarn

  before_save :normalize_stripes

  def normalize_stripes
    # input: [{color: '2028', width: 3}]
    # output:
    #   stripes: [[a, 3]]
    #   default_colors: { a: '2028' }
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
end
