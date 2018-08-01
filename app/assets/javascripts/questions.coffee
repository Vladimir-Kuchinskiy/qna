# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready turbolinks:load', ->
  questionsList = $('.questions_list')
  $('.edit_question_link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form.edit_question').show()
  $('.create_question_link').click (e) ->
    e.preventDefault()
    $('#new_question').show()

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionsList.append data
  })
