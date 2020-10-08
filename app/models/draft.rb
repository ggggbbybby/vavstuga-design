class Draft < ApplicationRecord
  belongs_to :user
  belongs_to :yarn

  before_save :assign_slug

  PIXEL_SIZE = 25

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
    draft['warp']
  end

  def treadling
    draft['weft']
  end

  def shafts
    threading.max
  end

  def treadles
    treadling.max
  end

  def color_palette
    (draft['warp_colors'].values + draft['weft_colors'].values).sort.uniq
  end

  def warp_pattern
    memo = []
    pos_x = warp_pixel_width - PIXEL_SIZE
    threading.each_with_index do |thread, idx|
      thread_color = draft['warp_colors'][idx.to_s] || draft['warp_colors']['default']
      if memo.last && memo.last[:color] == thread_color
        memo.last[:width] += PIXEL_SIZE
        memo.last[:x] -= PIXEL_SIZE
      else 
        memo << { x: pos_x, width: PIXEL_SIZE, color: thread_color }
      end
      pos_x -= PIXEL_SIZE
    end
    memo
  end

  def warp_pixel_width
    threading.length * PIXEL_SIZE
  end

  def weft_pattern
    memo = []
    pos_y = weft_pixel_height - PIXEL_SIZE

    treadling.each_with_index do |thread, idx|
      thread_color = draft['weft_colors'][idx.to_s] || draft['weft_colors']['default']
      if memo.last && memo.last[:color] == thread_color
        memo.last[:height] += PIXEL_SIZE
        memo.last[:y] -= PIXEL_SIZE
      else
        memo << { y: pos_y, height: PIXEL_SIZE, color: thread_color }
      end
      pos_y -= PIXEL_SIZE
    end
    memo
  end

  def weft_pixel_height
    treadling.length * PIXEL_SIZE
  end

  def mask_path
    warp_width = threading.length
    warp_length = treadling.length

    path = "M #{warp_width*PIXEL_SIZE},#{warp_length*PIXEL_SIZE}"
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

  def threading_path
    init_move = "M #{warp_pixel_width},#{weft_pixel_height + PIXEL_SIZE}"
    threading.each_with_object(init_move) do |warp, path|
      path << "\nm 0,#{PIXEL_SIZE * (warp-1)}"
      path << "\nv#{PIXEL_SIZE},h-#{PIXEL_SIZE},v-#{PIXEL_SIZE},h#{PIXEL_SIZE}"
      path << "\nm -#{PIXEL_SIZE},-#{PIXEL_SIZE * (warp-1)}"
    end
  end

  def treadling_path
    init_move = "M #{warp_pixel_width + PIXEL_SIZE},#{weft_pixel_height}"
    treadling.each_with_object([init_move]) do |weft, path|
      path << "m #{PIXEL_SIZE * (weft-1)},0"
      path << "v -#{PIXEL_SIZE}, h #{PIXEL_SIZE}, v #{PIXEL_SIZE},h -#{PIXEL_SIZE}"
      path << "m -#{PIXEL_SIZE * (weft-1)}, -#{PIXEL_SIZE}"
    end.join("\n")
  end


end
