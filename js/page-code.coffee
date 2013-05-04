url = "https://api.github.com/repos/crdx/0/commits/master"

getTooltipMessage = (commit) ->
    { tree: { sha }, message, committer: { name, date }} = commit

    sha1 = sha[0..6]
    timeAgo = util.timeAgo date

    toolTip = "[#{sha1}] #{message}<br><br>(by #{name}, #{timeAgo}"

    if (commit.committer.name != commit.author.name)
        toolTip += " and authored by #{commit.author.name}"

    return toolTip + ")"

setTooltip = ($element, msg) ->
    $element
        .attr("title", msg)
        .tooltip("fixTitle")
        .tooltip("show")

$ ->
    $(".project").each (i, element) ->
        $element = $ element
        $element.css "cursor", "default"

        $("b", $element).tooltip
            html: true
            animation: false
            trigger: "manual"
            placement: "right"

        mouseEnter = ->
            $this = $ this

            # if it's in the cache, just show and quit
            if $this.data "commit"
                setTooltip $this, $this.data("commit")
                $this.tooltip "show"
                return

            # not in the cache, so show the "loading" tooltip
            setTooltip $this, "<i class='w-glyphicon-clock'></i> Loading..."
            $this.tooltip "show"

            # reset cancelled flag
            $this.data "cancel", false

            repoUrl = url.replace /0/, $element.data("repo")

            $.ajax dataType: "jsonp", url: repoUrl, success: (result) ->
                if result.data
                    tooltipMsg = getTooltipMessage result.data.commit

                    $this.data "commit", tooltipMsg
                else
                    tooltipMsg = "unable to get commit"

                    if result.data.message
                        tooltipMsg += ": #{result.data.message}"

                # only show it if it hasn't been cancelled
                if not $this.data("cancel")
                    setTooltip $this, tooltipMsg

        mouseLeave = ->
            $this = $ this

            # hide the tooltip, and cancel any future tooltip-showing operations
            $this.tooltip "hide"
            $this.data "cancel", true

        # tooltips on <td>s make everything jump around, so use the <b>
        $("b", $element).hover mouseEnter, mouseLeave