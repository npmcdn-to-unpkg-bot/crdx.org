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
  $(@).select()
