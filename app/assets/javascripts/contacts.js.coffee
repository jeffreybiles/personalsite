# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  console.log("Ready!")
  $('#contact_form form').submit (event) ->
    console.log("submit form hit!", event)
    event.preventDefault()
    console.log("About to AJAX", $(this).serialize())
    $.ajax
      type: 'POST'
      url: '/contacts'
      dataType: 'json'
      success: (json, status) ->
        console.log("success!", json, status)
        if json.created
          $('#contact_form .header').slideUp()
          $('#contact_form .javascript_response').hide().html(json.html).slideDown()
        else
          alert('second choice')
          $('#contact_form .javascript_response').html(json.html)
      error: (json, status, errorThrown) ->
        console.log("Failure :(", json, status, errorThrown)

    return false