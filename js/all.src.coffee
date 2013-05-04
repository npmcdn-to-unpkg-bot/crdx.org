window.util = exports = {};

exports.timeAgo = (from) ->
    date = new Date();
    from = date.setTime Date.parse(from)

    seconds = (new Date() - from) / 1000
    minutes = Math.floor(seconds / 60)
    hours   = Math.round(minutes / 60)
    days    = Math.floor(minutes / 1440)
    months  = Math.floor(minutes / 43200)
    years   = Math.floor(minutes / 525960)

    switch
        when minutes is 0       then "less than a minute ago"
        when minutes is 1       then "a minute ago"
        when minutes < 45       then "#{minutes} minutes ago"
        when minutes < 90       then "about 1 hour ago"
        when minutes < 1440     then "about #{hours} hours ago"
        when minutes < 2880     then "1 day ago"
        when minutes < 43200    then "#{days} days ago"
        when minutes < 86400    then "about 1 month ago"
        when minutes < 525960   then "#{months} months ago"
        when minutes < 1051199  then "about 1 year ago"
        else                         "over #{years} years ago"

$ ->
    $domain   = $ "#domain"
    $output   = $ "#output"
    $input    = $ "#input"
    $generate = $ "#generate"

    $generate.on "click", (event) ->
        monthFromNow = parseInt((new Date()).getTime() / 1000 + 2592000, 10)
        prefix = ".#{$domain.val()}\tTRUE\t/\tFALSE\t#{monthFromNow}\t"
        output = ""

        for segment in $input.val().split(";")
            segment = $.trim(segment).split("=", 2)
            continue if segment.length < 2
            output += "#{prefix}#{segment[0]}\t#{segment[1]}\n"

        $output.val output
        return false

    $output.on "click", (event) ->
        $(this).select()

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