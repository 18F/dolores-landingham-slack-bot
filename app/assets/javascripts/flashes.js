$(function(){

  var flashCallback;

  flashCallback = function() {
    return $(".flashes").fadeOut();
  };

  $(".flashes").bind('click', (function(_this) {
    return function(event) {
      return $(".flashes").fadeOut();
    };
  })(this));

  setTimeout(flashCallback, 3000);
});
