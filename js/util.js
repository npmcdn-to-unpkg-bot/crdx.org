window.util = {
    timeAgo: function(from)
    {
        var date = new Date();
        from = date.setTime(Date.parse(from));

        var seconds = ((new Date() - from) / 1000);
        var minutes = Math.floor(seconds / 60);

        if (minutes === 0)      return "less than a minute ago";
        if (minutes === 1)      return "a minute ago";
        if (minutes < 45)       return minutes + " minutes ago";
        if (minutes < 90)       return "about 1 hour ago";
        if (minutes < 1440)     return "about " + Math.round(minutes / 60) + " hours ago";
        if (minutes < 2880)     return "1 day ago";
        if (minutes < 43200)    return Math.floor(minutes / 1440) + " days ago";
        if (minutes < 86400)    return "about 1 month ago";
        if (minutes < 525960)   return Math.floor(minutes / 43200) + " months ago";
        if (minutes < 1051199)  return "about 1 year ago";

        return "over " + Math.floor(minutes / 525960) + " years ago";
    }
};