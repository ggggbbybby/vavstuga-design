module DraftsHelper
  def gutter
    Draft::PIXEL_SIZE
  end

  def text_height
    Draft::PIXEL_SIZE
  end

  def drawdown_svg_height(draft)
    swatches_caption_baseline_y(draft) + 5
  end

  def drawdown_svg_width(draft)
    drawdown_width = (draft.threading.length * Draft::PIXEL_SIZE) + gutter + (draft.treadles * Draft::PIXEL_SIZE) + gutter + Draft::PIXEL_SIZE
    palette_width = (Draft::SWATCH_SIZE + gutter) * (draft.default_colors[:warp_colors].length + draft.default_colors[:weft_colors].length)
    [drawdown_width, palette_width].max
  end

  # shorthand coordinates for sections of the draft

  def treadling_x(draft)
    draft.warp_pixel_width + gutter
  end

  def threading_y(draft)
    draft.weft_pixel_height + gutter
  end

  def threading_colors_y(draft)
    threading_y(draft) + (draft.shafts * Draft::PIXEL_SIZE) + gutter
  end

  def treadling_colors_x(draft)
    treadling_x(draft) + (draft.treadles * Draft::PIXEL_SIZE) + gutter
  end

  def swatches_label_baseline_y(draft) # y for text is the baseline, not the top
    threading_colors_y(draft) + Draft::PIXEL_SIZE + 24
  end

  def swatches_y(draft)
    swatches_label_baseline_y(draft) + 10 # not quite a full gutter
  end

  def swatches_caption_baseline_y(draft)
    swatches_y(draft) + Draft::SWATCH_SIZE + 14
  end

  def warp_swatches(draft)
    draft.default_colors[:warp_colors].each_with_index.map do |color, idx| 
      {
        x: idx * (Draft::SWATCH_SIZE + gutter), 
        color: color,
        label: "##{color}" 
      }
    end
  end

  def weft_swatches_offset(draft)
    draft.default_colors[:warp_colors].length * (Draft::SWATCH_SIZE + gutter)
  end

  def weft_swatches(draft)
    offset = weft_swatches_offset(draft)
    draft.default_colors[:weft_colors].each_with_index.map do |color, idx|
      { 
        x: (idx * (Draft::SWATCH_SIZE + gutter)) + offset, 
        color: color, 
        label: "##{color}" 
      }
    end
  end
end