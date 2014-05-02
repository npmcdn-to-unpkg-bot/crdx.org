$ ->
  url = "https://api.github.com/repos/crdx/0/commits/master"

  getTooltipMessage = (commit) ->
    { tree: { sha }, message, committer: { name, date }} = commit

    sha1 = sha[0..6]
    timeAgo = util.timeAgo(date)

    toolTip = "[#{sha1}] #{message}<br><br>(by #{name}, #{timeAgo}"

    if commit.committer.name != commit.author.name
      toolTip += " and authored by #{commit.author.name}"

    return toolTip + ")"

  showTooltip = ($element, msg) ->
    $element.qtip(
      position:
        viewport: ".content"
      show:
        ready: true
      content:
        text: msg
      style:
        classes: "qtip-dark qtip-rounded tooltip" # TODO set this globally
    )

  $(".project").each (i, element) ->
    $element = $ element
    $tooltipTarget = $ ".project-state", $element

    mouseEnter = ->
      $this = $ @

      # if it's in the cache, just show and quit
      if $this.data "commit"
        showTooltip $this, $this.data("commit")
        return

      # not in the cache, so show the "loading" tooltip, and save a reference to this tooltip
      tooltip = showTooltip $this, "<i class='w-glyphicon-clock'></i> Loading..."
      tooltip = tooltip.qtip "api"

      # reset cancelled flag
      $this.data "cancel", false

      repoUrl = url.replace /0/, $element.data("repo")

      $.ajax dataType: "jsonp", url: repoUrl, success: (result) ->
        if result.data.commit
          tooltipMsg = getTooltipMessage result.data.commit
        else
          tooltipMsg = "unable to get commit"

          if result.data.message
            tooltipMsg += ": #{result.data.message}"

        # store it (yes, even if it's an error message)
        $this.data "commit", tooltipMsg

        # only set it if it hasn't been cancelled and we have something to show
        if not $this.data("cancel")
          tooltip.set "content.text", tooltipMsg

    mouseLeave = ->
      $this = $ @

      # mark as cancelled (MAY NOT NEED)
      $this.data "cancel", true

    $tooltipTarget.hover mouseEnter, mouseLeave
