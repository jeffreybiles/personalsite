# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('#contact_form form').submit (event) ->
    $('#contact_button').attr('disabled': 'disabled')
    event.preventDefault()
    $.ajax
      type: 'POST'
      url: $(this).attr('action')
      data: $(this).serialize()
      dataType: 'json'
      success: (json, status) ->
        console.log("success!", json, status)
        if json.created
          $('#contact_form .header').slideUp()
          $('#contact_form .javascript_response').hide().html(json.html).slideDown()
        else
          alert('second choice')
          $('#contact_form .javascript_response').html(json.html)
      after: ->
        $('#contact_button').removeAttr('disabled')

    return false