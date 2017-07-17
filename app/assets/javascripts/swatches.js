$(document).ready ( function(){
  var selectedColor;

  var pickColor = function(stripe, color) {
    var bgColor = bg(color);
    $(`.target[data-stripe="${stripe}"]`).css('background-image', bgColor);
    $(`.color-code[data-stripe="${stripe}"]`).html(`#${color}`);
    $(`.color-name[data-stripe="${stripe}"]`).html(colorName(color));
    $(`.color-${stripe}`).css('background-image', bgColor);
  };

  var createSwatch = function(indx, color, container = "#swatches") {
    var swatch = $('<div class="swatch"></div>');
    swatch.attr('data-color', color.code);
    swatch.css('background-image', bg(color.code));
    swatch.attr('title', color.name);
    $(container).append(swatch);
  };
  $.each(colors, createSwatch);

  var selectColor = function(e) {
    resetSelectedColor();
    selectedColor = e.target.dataset.color;
    $(e.target).addClass('selected');
  };

  var resetSelectedColor = function() {
    selectedColor = null;
    $('.swatch.selected').removeClass('selected');
  };

  var setColor = function(e) {
    if(selectedColor) {
      var stripe = e.target.dataset.stripe;
      pickColor(stripe, selectedColor);
      resetSelectedColor();
    }
  };

  $('.swatch').click(selectColor);
  $('.target').click(setColor);
  $('.stripe').click(setColor);

  var setDefaults = function() {
    $.each(defaults, pickColor);
    resetSelectedColor();
  };
  setDefaults();
  $('#reset-defaults').click(setDefaults);
})
