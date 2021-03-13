$(document).ready( function(){

  const PIXEL_SIZE = window.draft.pixel_size;
  const draft = window.draft;
  const warp_width = draft.draft.warp.length;
  const weft_height = draft.draft.weft.length;

  var setWarpColor = function(e) {
    // challenge: when a user clicks on threading color box, figure out which warp block they clicked on
    // which thread did they click on?
    // which block does that thread belong to?
    const new_color = $('#selected-color').val();
    if (new_color) {
      const offset = $(this).offset();
      const thread_idx = warp_width - Math.ceil((e.pageX - offset.left) / PIXEL_SIZE)
      const warp_block_idx = draft.warp_blocks[thread_idx];
      const warp_pattern = $(`#warp-block-${warp_block_idx}`);
      warp_pattern.attr('fill', `url(#color-${new_color})`)
    }
  }

  var setWeftColor = function(e) {
    const new_color = $('#selected-color').val();
    if (new_color) {
      const offset = $(this).offset();
      const pick_idx = weft_height - Math.ceil((e.pageY - offset.top) / PIXEL_SIZE)
      const weft_block_idx = draft.weft_blocks[pick_idx]
      const weft_pattern = $(`#weft-block-${weft_block_idx}`);
      weft_pattern.attr('fill', `url(#color-${new_color})`)
    }
  }
  
  $('#threading-colors').click(setWarpColor);
  $('#treadling-colors').click(setWeftColor);
});