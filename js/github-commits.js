(function() {
    var url = "https://api.github.com/repos/crdx/0/commits";

    function getTooltip(commit)
    {
        var toolTip = "[" + commit.tree.sha.substring(0, 6) + "] "
            + commit.message
            + "<br><br>(by " + commit.committer.name + " "
            + timeAgo(commit.committer.date);

        if (commit.committer.name !== commit.author.name)
            toolTip += " and authored by " + commit.author.name;

        return toolTip + ")";
    }

    function setTooltip($element, msg)
    {
        $element
            .attr('title', msg)
            .tooltip('fixTitle')
            .tooltip('show');
    }

    $(function() {
        $(".project").each(function(i, element) {
            var $element = $(element);
            $element.css("cursor", "default");

            $("b", $element).tooltip({
                html: true,
                animation: false,
                trigger: "manual",
                placement: "right"
            });

            var mouseEnter = function()
            {
                var $this = $(this);

                // if it's in the cache, just show and quit
                if ($this.data("commit"))
                {
                    setTooltip($this, $this.data("commit"));
                    $this.tooltip("show");
                    return;
                }

                // not in the cache, so show the 'loading' tooltip
                setTooltip($this, "<i class='w-glyphicon-clock'></i> Loading...");
                $this.tooltip("show");
                $this.data("cancel", false); // reset cancelled flag

                var repoUrl = url.replace(/0/, $element.data("repo"));

                $.ajax({ dataType: "jsonp", url: repoUrl, success: function(result) {
                    var tooltipMsg;

                    if (result.data[0])
                    {
                        tooltipMsg = getTooltip(result.data[0].commit);

                        $this.data("commit", tooltipMsg);
                    }
                    else
                    {
                        tooltipMsg = "unable to get commit";

                        if (result.data.message)
                            tooltipMsg += ": " + result.data.message;
                    }

                    // only show it if it hasn't been cancelled
                    if (!$this.data("cancel"))
                        setTooltip($this, tooltipMsg);
                }});
            };

            var mouseLeave = function()
            {
                var $this = $(this);

                // hide the tooltip, and cancel any future tooltip-showing operations
                $this.tooltip("hide");
                $this.data("cancel", true);
            };

            // tooltips on <td>s make everything jump around, so use the <b>
            $("b", $element).hover(mouseEnter, mouseLeave);
        });
    });
})();