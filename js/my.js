function timeAgo(from)
{
    var date = new Date();
    from = date.setTime(Date.parse(from));

    var distance_in_seconds = ((new Date() - from) / 1000);
    var distance_in_minutes = Math.floor(distance_in_seconds / 60);

    if (distance_in_minutes === 0)      return "less than a minute ago";
    if (distance_in_minutes === 1)      return "a minute ago";
    if (distance_in_minutes < 45)       return distance_in_minutes + " minutes ago";
    if (distance_in_minutes < 90)       return "about 1 hour ago";
    if (distance_in_minutes < 1440)     return "about " + Math.round(distance_in_minutes / 60) + " hours ago";
    if (distance_in_minutes < 2880)     return "1 day ago";
    if (distance_in_minutes < 43200)    return Math.floor(distance_in_minutes / 1440) + " days ago";
    if (distance_in_minutes < 86400)    return "about 1 month ago";
    if (distance_in_minutes < 525960)   return Math.floor(distance_in_minutes / 43200) + " months ago";
    if (distance_in_minutes < 1051199)  return "about 1 year ago";

    return "over " + Math.floor(distance_in_minutes / 525960) + " years ago";
}