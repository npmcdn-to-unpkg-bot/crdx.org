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
