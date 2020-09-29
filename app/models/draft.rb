class Draft < ApplicationRecord
  belongs_to :user
  belongs_to :yarn

  before_save :assign_slug

  PIXEL_SIZE = 10

  def assign_slug
    self.slug ||= SecureRandom.hex(12)
  end

  def self.permitted
    [
      :name,
      :slug,
      :public,
      :yarn_id,
      draft_data: [
        :shaft_count,
        :treadle_count,
        :warp,
        :weft,
        :warp_colors,
        :weft_colors,
        :tieup
      ]
    ]
  end

  def threading
    draft.with_indifferent_access[:warp]
  end

  def treadling
    draft.with_indifferent_access[:weft]
  end

  def mask_path
    warp_width = threading.length
    warp_length = treadling.length

    path = "m #{warp_width*PIXEL_SIZE},#{warp_length*PIXEL_SIZE}"
    threading.each do |warp_thread|
      treadling.each do |treadle|
        if warp_thread != treadle
          path << "\nv-#{PIXEL_SIZE},h-#{PIXEL_SIZE},v#{PIXEL_SIZE},h#{PIXEL_SIZE}"
        end
        path << "\nm-#{PIXEL_SIZE},0"
      end
      path << "\nm#{warp_width*PIXEL_SIZE},-#{PIXEL_SIZE}"
    end
    path
  end
end
