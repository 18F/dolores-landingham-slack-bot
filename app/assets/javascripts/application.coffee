//= require jquery
//= require jquery_ujs
//= require_tree .

$ ->
  flashCallback = ->
    $(".flashes").fadeOut()
  $(".flashes").bind 'click', (event) =>
    $(".flashes").fadeOut()
  setTimeout flashCallback, 3000
