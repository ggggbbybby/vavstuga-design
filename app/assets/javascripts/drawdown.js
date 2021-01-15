$(document).ready( function(){

  var setColor = function(e) {
    console.log("you clicked", e.target);
    var warp_pattern = $('pattern#warp rect');
    
  }
  
  $('#threading-colors').click(setColor);
  $('#treadling-colors').click(setColor);
});