# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->

#  eu = []
#  us = []
#  eu_link = 'http://eu.battle.net/api/wow/realm/status'
#  us_link = 'http://us.battle.net/api/wow/realm/status'
#  $.getJSON eu_link, (data) ->
#    eu_realms = data
#  $.getJSON us_link, (data) ->
#    us_realms = data
#
#  for d,i in eu_realms
#    rname = eu_realms['realms'][d]['name']
#    eu.push rname
#
#  for d,i in us_realms
#    rname = eu_realms['realms'][d]['name']
#    us.push rname
#
#  selected = $('#character_region').find(":selected").text()
#  alert selected
#  if (selected == 'eu')
#    $("#character_realm").autocomplete({
#      source: eu
#    })
#  if (selected == 'us')
#    $("#character_realm").autocomplete({
#      source: us
#    })


  $.getScript('http://localhost:1337/socket.io/socket.io.js')
    .done (script, textStatus) ->
      socket = io.connect('http://localhost:1337')
      character = $.parseJSON(gon.character)
      character.class = character.charClass
      socket.emit 'join', {char_id: character.id}
      console.log character.id

      $('#sendserver').on 'click', ->
        socket.emit 'sendserver', {charstuff:gon.charstuff,char_id:character.id, character:character}
        $('#console').append('<li>'+"Starting simulation! The simulation may take several seconds."+'</li>')
        $('#console').scrollTop($('#console')[0].scrollHeight)

        return false

      socket.on 'sendserver', (msg) ->
        $('#console').append('<li>'+msg+'</li>')
        $('#console').scrollTop($('#console')[0].scrollHeight)

      socket.on 'recievedps', (msg) ->
        weights = []
        $('#console').append('<li>Your stat weights are the following (over 5000 iterations):</li>')
        for d,i of msg.weights
          name = msg.weights[d]['$']['name']
          value = msg.weights[d]['$']['normalized']
          weights.push name+': '+value
          $('#console').append('<li>'+name+': '+value+'</li>')
          $('#console').scrollTop($('#console')[0].scrollHeight)

        $('#showdps').empty()
        $('#showdps').append('<p>'+msg.dps+'</p>')
        $('#console').append('<li>'+'Simulation over. Your dps was: '+msg.dps+'</li>')
        $('#console').scrollTop($('#console')[0].scrollHeight)
        return
