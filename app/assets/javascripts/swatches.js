$(document).ready ( function(){
  var selectedColor;

  var pickColor = function(stripe, color) {
    var bgColor = bg(color);
    var dataStripe = "[data-stripe=" + stripe + "]";
    $(".target" + dataStripe).css('background-image', bgColor);
    $(".color-code" + dataStripe).html("#" + color);
    $(".color-name" + dataStripe).html(colorName(color));
    $(".color-" + stripe).css('background-image', bgColor);
  };

  var createSwatch = function(indx, color) {
    var swatch = $('<div class="swatch"></div>');
    swatch.attr('data-color', color.code);
    swatch.css('background-image', bg(color.code));
    swatch.attr('title', color.name);
    $("#swatches").append(swatch);
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
