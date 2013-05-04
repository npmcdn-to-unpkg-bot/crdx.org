(function() {
  var exports, getTooltipMessage, setTooltip, url;

  window.util = exports = {};

  exports.timeAgo = function(from) {
    var date, days, hours, minutes, months, seconds, years;

    date = new Date();
    from = date.setTime(Date.parse(from));
    seconds = (new Date() - from) / 1000;
    minutes = Math.floor(seconds / 60);
    hours = Math.round(minutes / 60);
    days = Math.floor(minutes / 1440);
    months = Math.floor(minutes / 43200);
    years = Math.floor(minutes / 525960);
    switch (false) {
      case minutes !== 0:
        return "less than a minute ago";
      case minutes !== 1:
        return "a minute ago";
      case !(minutes < 45):
        return "" + minutes + " minutes ago";
      case !(minutes < 90):
        return "about 1 hour ago";
      case !(minutes < 1440):
        return "about " + hours + " hours ago";
      case !(minutes < 2880):
        return "1 day ago";
      case !(minutes < 43200):
        return "" + days + " days ago";
      case !(minutes < 86400):
        return "about 1 month ago";
      case !(minutes < 525960):
        return "" + months + " months ago";
      case !(minutes < 1051199):
        return "about 1 year ago";
      default:
        return "over " + years + " years ago";
    }
  };

  $(function() {
    var $domain, $generate, $input, $output;

    $domain = $("#domain");
    $output = $("#output");
    $input = $("#input");
    $generate = $("#generate");
    $generate.on("click", function(event) {
      var monthFromNow, output, prefix, segment, _i, _len, _ref;

      monthFromNow = parseInt((new Date()).getTime() / 1000 + 2592000, 10);
      prefix = "." + ($domain.val()) + "\tTRUE\t/\tFALSE\t" + monthFromNow + "\t";
      output = "";
      _ref = $input.val().split(";");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        segment = _ref[_i];
        segment = $.trim(segment).split("=", 2);
        if (segment.length < 2) {
          continue;
        }
        output += "" + prefix + segment[0] + "\t" + segment[1] + "\n";
      }
      $output.val(output);
      return false;
    });
    return $output.on("click", function(event) {
      return $(this).select();
    });
  });

  url = "https://api.github.com/repos/crdx/0/commits/master";

  getTooltipMessage = function(commit) {
    var date, message, name, sha, sha1, timeAgo, toolTip, _ref, _ref1;

    (_ref = commit.tree, sha = _ref.sha), message = commit.message, (_ref1 = commit.committer, name = _ref1.name, date = _ref1.date);
    sha1 = sha.slice(0, 7);
    timeAgo = util.timeAgo(date);
    toolTip = "[" + sha1 + "] " + message + "<br><br>(by " + name + ", " + timeAgo;
    if (commit.committer.name !== commit.author.name) {
      toolTip += " and authored by " + commit.author.name;
    }
    return toolTip + ")";
  };

  setTooltip = function($element, msg) {
    return $element.attr("title", msg).tooltip("fixTitle").tooltip("show");
  };

  $(function() {
    return $(".project").each(function(i, element) {
      var $element, mouseEnter, mouseLeave;

      $element = $(element);
      $element.css("cursor", "default");
      $("b", $element).tooltip({
        html: true,
        animation: false,
        trigger: "manual",
        placement: "right"
      });
      mouseEnter = function() {
        var $this, repoUrl;

        $this = $(this);
        if ($this.data("commit")) {
          setTooltip($this, $this.data("commit"));
          $this.tooltip("show");
          return;
        }
        setTooltip($this, "<i class='w-glyphicon-clock'></i> Loading...");
        $this.tooltip("show");
        $this.data("cancel", false);
        repoUrl = url.replace(/0/, $element.data("repo"));
        return $.ajax({
          dataType: "jsonp",
          url: repoUrl,
          success: function(result) {
            var tooltipMsg;

            if (result.data) {
              tooltipMsg = getTooltipMessage(result.data.commit);
              $this.data("commit", tooltipMsg);
            } else {
              tooltipMsg = "unable to get commit";
              if (result.data.message) {
                tooltipMsg += ": " + result.data.message;
              }
            }
            if (!$this.data("cancel")) {
              return setTooltip($this, tooltipMsg);
            }
          }
        });
      };
      mouseLeave = function() {
        var $this;

        $this = $(this);
        $this.tooltip("hide");
        return $this.data("cancel", true);
      };
      return $("b", $element).hover(mouseEnter, mouseLeave);
    });
  });

}).call(this);

/*
//@ sourceMappingURL=all.js.map
*/