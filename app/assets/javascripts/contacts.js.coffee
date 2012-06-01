# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  console.log("Ready!")
  $('#contact_form form').submit (event) ->
    console.log("submit form hit!", event)
    $('#contact_button').attr('disabled': 'disabled')
    event.preventDefault()
    console.log("About to AJAX")
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
        console.log("after")
        $('#contact_button').removeAttr('disabled')

    return false