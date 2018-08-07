# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready turbolinks:load', ->
  answersList = $('.answers')

  $('.edit_answer_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('#edit_answer_' + answer_id).show()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      appendQuestion(data)
  })
  appendQuestion = (data) ->
    answersList.append JST['templates/answer'](data)
