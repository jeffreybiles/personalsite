jQuery ->
  $('.expansion').hide()

  $('.expandable').click ->
    $(this).hide().fadeOut(700)
    $(this).parent().children('.expansion').fadeIn(700)