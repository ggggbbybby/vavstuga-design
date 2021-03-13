$(document).ready(function () {

  const PIXEL_SIZE = window.draft.pixel_size;
  const draft = window.draft;
  var warp_width = draft.draft.warp.length;
  var weft_height = draft.draft.weft.length;
  // editing mode lets you change individual thread colors
  const are_you_editing = $('#edit-frame').length > 0

  var setWarpColor = function (e) {
    // challenge: when a user clicks on threading color box, figure out which warp block they clicked on
    // which thread did they click on?
    // which block does that thread belong to?
    const new_color = $('#selected-color').val();
    if (new_color) {
      const offset = $(this).offset();
      const thread_idx = warp_width - Math.ceil((e.pageX - offset.left) / PIXEL_SIZE)
      const warp_block_idx = are_you_editing ? thread_idx : draft.warp_blocks[thread_idx];
      const warp_pattern = $(`#warp-block-${warp_block_idx}`);
      warp_pattern.attr('fill', `url(#color-${new_color})`)
      draft.draft.warp_colors[thread_idx] = new_color;
    }
  }

  var setWeftColor = function (e) {
    const new_color = $('#selected-color').val();
    if (new_color) {
      const offset = $(this).offset();
      const pick_idx = weft_height - Math.ceil((e.pageY - offset.top) / PIXEL_SIZE)
      const weft_block_idx = are_you_editing ? pick_idx : draft.weft_blocks[pick_idx]
      var weft_pattern = $(`#weft-block-${weft_block_idx}`);
      weft_pattern.attr('fill', `url(#color-${new_color})`)
      draft.draft.weft_colors[pick_idx] = new_color;
    }
  }

  // helpful functions for moving svg parts around to add warp & weft threads
  const stretchBox = function (stretchX, stretchY) {
    return (name) => {
      const box = $(name)
      if (stretchX > 0) box.attr('width', parseInt(box.attr('width')) + stretchX)
      if (stretchY > 0) box.attr('height', parseInt(box.attr('height')) + stretchY)
    }
  }

  const moveBox = function (moveX, moveY) {
    return (name) => {
      const box = $(name)
      if (moveX > 0) box.attr('x', parseInt(box.attr('x')) + moveX)
      if (moveY > 0) box.attr('y', parseInt(box.attr('y')) + moveY)
    }
  }

  const init_move_regex = /^M (\d+),(\d+)/
  const shift_x = (move_amount) => ((str, x, y) => `M ${parseInt(x) + move_amount},${y}`)
  const shift_y = (move_amount) => ((str, x, y) => `M ${x},${parseInt(y) + move_amount}`)
  const movePath = function (moveX, moveY) {
    return (name) => {
      const path = $(name);
      const new_d = path.attr('d').replace(init_move_regex, shift_x(moveX)).replace(init_move_regex, shift_y(moveY))
      path.attr('d', new_d);
    }
  }

  const boxes_to_stretch = [
    '#drawdown',
    '#drawdown-grid',
    '#profile-mask',
    '#profile-mask-path',
  ];

  const boxes_to_move = [
    '#tieup'
  ];

  const paths_to_move = [
    '#threading-path',
    '#treadling-path',
    '#tieup-path',
    '#profile-mask-path'
  ];

  const create_block = function ({ id, width, height }) {
    block = $(document.createElementNS('http://www.w3.org/2000/svg', 'rect'))
    block.attr('id', id)
    block.attr('x', 0)
    block.attr('y', 0)
    block.attr('width', width)
    block.attr('height', height)
    block.attr('fill', 'none')
    return block;
  }

  const addWarpThreads = function (e) {
    // shift everything 5 boxes horizontally
    // fixme: warp colors are anchored on the left, need to be anchored on the right
    warp_width += 5
    const amount_to_move = 5 * PIXEL_SIZE;
    [...boxes_to_stretch, '#threading', '#threading-colors', '#threading-colors-grid', '#warp-drawdown', 'pattern#warp'].forEach(stretchBox(amount_to_move, 0));
    [...boxes_to_move, '#treadling', '#treadling-colors', '#treadling-colors-grid', '#weft-drawdown'].forEach(moveBox(amount_to_move, 0));
    paths_to_move.forEach(movePath(amount_to_move, 0));
    // add new warp-blocks for color, shift the old ones to the right
    const warp_block_idxs = [...Array(warp_width).keys()];
    warp_block_idxs.forEach((warp_block_idx) => {
      const warp_block_id = `warp-block-${warp_block_idx}`;
      var warp_block = $(`#${warp_block_id}`);
      if (warp_block.length == 0) {
        warp_block = create_block({
          id: warp_block_id,
          width: PIXEL_SIZE,
          height: weft_height * PIXEL_SIZE
        });
        $('pattern#warp').append(warp_block);
      }
      warp_block.attr('x', (warp_width - warp_block_idx - 1) * PIXEL_SIZE)
    })
  }

  const addWeftPicks = function (e) {
    weft_height += 5
    const amount_to_move = 5 * PIXEL_SIZE;
    [...boxes_to_stretch, '#treadling', '#treadling-colors', '#treadling-colors-grid', '#weft-drawdown', 'pattern#weft'].forEach(stretchBox(0, amount_to_move));
    [...boxes_to_move, '#threading', '#threading-colors', '#threading-colors-grid', '#warp-drawdown'].forEach(moveBox(0, amount_to_move));
    paths_to_move.forEach(movePath(0, amount_to_move));
    // add new weft-blocks for color, shift the old ones down
    const weft_block_idxs = [...Array(weft_height).keys()];
    weft_block_idxs.forEach((weft_block_idx) => {
      const weft_block_id = `weft-block-${weft_block_idx}`
      var weft_block = $(`#${weft_block_id}`)
      if (weft_block.length == 0) {
        weft_block = create_block({
          id: weft_block_id,
          width: warp_width * PIXEL_SIZE,
          height: PIXEL_SIZE
        });
        $('pattern#weft').append(weft_block);
      }
      weft_block.attr('y', (weft_height - weft_block_idx - 1) * PIXEL_SIZE)
    });
  }

  // hook it all up
  $('#threading-colors').click(setWarpColor);
  $('#treadling-colors').click(setWeftColor);
  $('#add-warp-threads').click(addWarpThreads);
  $('#add-weft-picks').click(addWeftPicks);
});