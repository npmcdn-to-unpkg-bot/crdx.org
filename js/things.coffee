$ ->
  # make all external links open in a new window
  links = $(".nav-container a").filter(-> this.hostname != window.location.hostname)
  links.attr "target", "_blank"

  # add "is-scrolled" class to <html> when we've scrolled down
  $(window).on "scroll", (event) ->
    $("html").toggleClass "is-scrolled", $(window).scrollTop() > 0

  # initialise tooltips
  $(".js-tooltip").qtip(
    position:
      my: "top right"
      at: "bottom left"
    style:
      classes: "qtip-dark qtip-rounded tooltip" # TODO set this globally
  )
