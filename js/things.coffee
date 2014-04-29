# make all external links open in a new window
links = $(".nav-container a").filter(-> this.hostname != window.location.hostname)
links.attr "target", "_blank"

# add "is-scrolled" class to body when we've scrolled down
$(window).on "scroll", (event) ->
  $("body").toggleClass "is-scrolled", $(window).scrollTop() > 0

# initialise all tooltips
$(".js-tooltip").tooltip(placement: "bottom")
