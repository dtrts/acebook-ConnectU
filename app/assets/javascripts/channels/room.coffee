//= require cable
//= require_self
//= require_tree .

App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server


  disconnected: ->
    # Called when the subscription has been terminated by the server


  received: (data) ->
    $('#messages').append data['message']
    messages_div = document.getElementById("messages");
    messages_div.scrollTop = messages_div.scrollHeight;

  speak: (message) ->
    @perform 'speak', message: message

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13
        App.room.speak event.target.value
        event.target.value = ''
        event.preventDefault()

