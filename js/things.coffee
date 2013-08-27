$ ->
    # make all external links open in a new window
    links = $(document.links).filter(-> this.hostname != window.location.hostname)
    links.attr "target", "_blank"

    $(window).on "scroll", (event) ->
        $("body").toggleClass "is-scrolled", $(window).scrollTop() > 0
