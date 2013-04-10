$(function() {
    $("#generate").on("click", function(event) {
        var prefix = "." + $("#domain").val() + "\tTRUE\t/\tFALSE\t" + parseInt((new Date()).getTime() / 1000 + 2592000, 10) + "\t"; // 1 month?
        var segments = $("#input").val().split(";");
        var output = "";

        for (var i = 0; i < segments.length; i++)
        {
            var segment = $.trim(segments[i]).split("=", 2);

            if (segment.length < 2)
                continue;

            output += prefix + segment[0] + "\t   " + segment[1] + "\n";
        }

        $("#output").val(output);
        return false;
    });

    $("#output").on("click", function(event) {
        $(this).select();
    });
});
