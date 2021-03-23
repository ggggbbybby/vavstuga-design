class Draft < ApplicationRecord
  belongs_to :user
  belongs_to :yarn

  before_save :assign_slug
  before_create :skeleton_draft

  PIXEL_SIZE = 15
  SWATCH_SIZE = 70

  def assign_slug
    self.slug ||= SecureRandom.hex(12)
  end

  def self.permitted
    [
      :name,
      :slug,
      :public,
      :yarn_id,
      :vavstuga_category_name,
      :vavstuga_category_url,
      :vavstuga_product_name,
      :vavstuga_product_url,
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

  def self.with_defaults
    new(draft: {
      'shaft_count' => 4,
      'treadle_count' => 4,
      'warp' => [],
      'weft' => [],
      'tieup' => [],
      'warp_colors' => {},
      'weft_colors' => {},
    })
  end

  def skeleton_draft
    draft['warp'] = (1..shafts).to_a
    draft['weft'] = (1..treadles).to_a
    draft['tieup'] = (1..treadles).map { |t| t <= shafts ? [t] : [] }
    draft['warp_colors'] = { 'default' => yarn.default_warp }
    draft['weft_colors'] = { 'default' => yarn.default_weft }
  end

  def to_json(mode: :show)
    {
      name: name,
      slug: slug,
      draft: draft,
      pixel_size: PIXEL_SIZE,
      warp_blocks: warp_blocks,
      weft_blocks: weft_blocks,
    }.to_json.html_safe
  end

  def has_breadcrumbs?
    vavstuga_product_url.present? && vavstuga_product_name.present? && vavstuga_category_url.present? && vavstuga_category_name.present?
  end

  def threading
    draft['warp'] || []
  end

  def treadling
    draft['weft'] || []
  end

  def tieup
    draft['tieup'] || []
  end

  def shafts
    draft['shaft_count'].to_i
  end

  def treadles
    draft['treadle_count'].to_i
  end

  def warp_colors
    draft['warp_colors'] || { 'default' => yarn.default_warp }
  end

  def weft_colors
    draft['weft_colors'] || { 'default' => yarn.default_weft }
  end

  def color_palette
    yarn.colors.map { |c| c['code'] }.sort.uniq
  end

  def default_colors
    {
      warp_colors: [warp_colors['default'], *warp_colors.values].uniq,
      weft_colors: [weft_colors['default'], *weft_colors.values].uniq
    }
  end

  def warp_pattern(mode: :show)
    memo = []
    pos_x = warp_pixel_width - PIXEL_SIZE
    threading.each_with_index do |thread, idx|
      thread_color = warp_colors[idx.to_s] || warp_colors['default']
      if mode == :show && memo.last && memo.last[:color] == thread_color
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

  def weft_pattern(mode: :show)
    memo = []
    pos_y = weft_pixel_height - PIXEL_SIZE

    treadling.each_with_index do |thread, idx|
      thread_color = weft_colors[idx.to_s] || weft_colors['default']
      if mode == :show && memo.last && memo.last[:color] == thread_color
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
    # drawing a box on the mask means that the warp will show (shaft is up)
    warp_width = threading.length
    warp_length = treadling.length

    path = "M #{warp_width*PIXEL_SIZE} #{warp_length*PIXEL_SIZE}"
    treadling.each do |treadle|
      threading.each do |warp_thread|
        treadle ||= 1 # if there's nothing there, don't have a cow
        sinking_shafts = tieup[treadle - 1]
        if !sinking_shafts.include?(warp_thread)
          path << "\nv-#{PIXEL_SIZE} h-#{PIXEL_SIZE} v#{PIXEL_SIZE} h#{PIXEL_SIZE}"
        end
        path << "\nm-#{PIXEL_SIZE} 0"
      end
      path << "\nm#{warp_width*PIXEL_SIZE} -#{PIXEL_SIZE}"
    end
    path
  end

  def threading_path
    init_move = "M #{warp_pixel_width},#{weft_pixel_height + PIXEL_SIZE}"
    threading.each_with_object([init_move]) do |warp, path|
      warp ||= 1 # don't go out of bounds if a thread is missing
      path << "m 0 #{PIXEL_SIZE * (warp-1)}"
      path << "v #{PIXEL_SIZE}  h -#{PIXEL_SIZE} v -#{PIXEL_SIZE}  h #{PIXEL_SIZE}"
      path << "m -#{PIXEL_SIZE} -#{PIXEL_SIZE * (warp-1)}"
    end.join("\n")
  end

  def treadling_path
    init_move = "M #{warp_pixel_width + PIXEL_SIZE},#{weft_pixel_height}"
    treadling.each_with_object([init_move]) do |weft, path|
      weft ||= 1 # don't go out of bounds if a treadle is missing
      path << "m #{PIXEL_SIZE * (weft-1)} 0"
      path << "v -#{PIXEL_SIZE} h #{PIXEL_SIZE} v #{PIXEL_SIZE} h -#{PIXEL_SIZE}"
      path << "m -#{PIXEL_SIZE * (weft-1)} -#{PIXEL_SIZE}"
    end.join("\n")
  end

  def tieup_path
    init_move = "M #{warp_pixel_width + PIXEL_SIZE},#{weft_pixel_height + PIXEL_SIZE}"
    tieup.each_with_object([init_move]) do |shafts, path|
      shafts.each do |shaft|
        path << "m 0 #{PIXEL_SIZE*(shaft-1)}"
        path << "v #{PIXEL_SIZE} h #{PIXEL_SIZE} v -#{PIXEL_SIZE} h -#{PIXEL_SIZE}"
        path << "m 0 -#{PIXEL_SIZE*(shaft-1)}"
      end
      path << "m #{PIXEL_SIZE},0"
    end.join("\n")
  end
end
