class Draft < ApplicationRecord
  belongs_to :user
  belongs_to :yarn

  before_save :assign_slug

  PIXEL_SIZE = 15

  def assign_slug
    self.slug ||= SecureRandom.hex(12)
  end

  def self.permitted
    [
      :name,
      :slug,
      :public,
      :yarn_id,
      draft: [
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

  def to_json
    {
      name: name,
      slug: slug,
      draft: draft,
      pixel_size: PIXEL_SIZE,
      warp_blocks: warp_blocks,
      weft_blocks: weft_blocks,
    }.to_json.html_safe
  end

  def threading
    draft['warp'] || []
  end

  def treadling
    draft['weft'] || []
  end

  def shafts
    [draft['shaft_count'].to_i, threading.max].compact.min
  end

  def treadles
    [draft['treadle_count'].to_i, treadling.max].compact.min
  end

  def warp_colors
    draft['warp_colors'] || { 'default' => '2000' }
  end

  def weft_colors
    draft['weft_colors'] || { 'default' => '2005' }
  end

  def color_palette
    yarn.colors.map { |c| c['code'] }.sort.uniq
  end

  def warp_pattern
    memo = []
    pos_x = warp_pixel_width - PIXEL_SIZE
    threading.each_with_index do |thread, idx|
      thread_color = warp_colors[idx.to_s] || warp_colors['default']
      if memo.last && memo.last[:color] == thread_color
        memo.last[:width] += PIXEL_SIZE
        memo.last[:x] -= PIXEL_SIZE
        memo.last[:threads] << idx
      else 
        memo << { x: pos_x, width: PIXEL_SIZE, color: thread_color, threads: [idx] }
      end
      pos_x -= PIXEL_SIZE
    end
    memo
  end

  def warp_blocks
    # { thread_idx => warp_block_id }
    memo = {}
    warp_pattern.each_with_index do |block, block_idx|
      block[:threads].each do |thread_idx|
        memo[thread_idx] = block_idx
      end
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
      thread_color = weft_colors[idx.to_s] || weft_colors['default']
      if memo.last && memo.last[:color] == thread_color
        memo.last[:height] += PIXEL_SIZE
        memo.last[:y] -= PIXEL_SIZE
        memo.last[:threads] << idx
      else
        memo << { y: pos_y, height: PIXEL_SIZE, color: thread_color, threads: [idx] }
      end
      pos_y -= PIXEL_SIZE
    end
    memo
  end

  def weft_blocks
    # { thread_idx => weft_block_idx }
    memo = {}
    weft_pattern.each_with_index do |block, block_idx|
      block[:threads].each do |thread_idx|
        memo[thread_idx] = block_idx
      end
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
    threading.each_with_object([init_move]) do |warp, path|
      path << "m 0,#{PIXEL_SIZE * (warp-1)}"
      path << "v #{PIXEL_SIZE}, h -#{PIXEL_SIZE}, v -#{PIXEL_SIZE}, h #{PIXEL_SIZE}"
      path << "m -#{PIXEL_SIZE}, -#{PIXEL_SIZE * (warp-1)}"
    end.join("\n")
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
