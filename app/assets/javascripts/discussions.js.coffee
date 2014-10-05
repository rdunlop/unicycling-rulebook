$(document).ready ->
  $('.js--days-ago').each (i, elem) ->
    str = moment($(elem).attr('datetime')).fromNow()
    $(elem).text(str)
