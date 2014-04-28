# make all external links open in a new window
links = $(".nav-container a").filter(-> this.hostname != window.location.hostname)
links.attr "target", "_blank"

$(window).on "scroll", (event) ->
  $("body").toggleClass "is-scrolled", $(window).scrollTop() > 0

#$(".js-tooltip").on "mouseover", (event) ->
#  $(this).tooltip()

$(".js-tooltip").tooltip(placement: "bottom")
