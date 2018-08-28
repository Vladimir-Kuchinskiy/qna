# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready turbolinks:load', ->
  commentsListForQuestions   = $('.comments-for-question')
  addCommentToQuestionButton = $('.add-comment-to-question')
  addCommentToQuestionButton.click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form#new_comment').show()
  $('.cancel-comment').click (e) ->
    e.preventDefault()
    $('form#new_comment').hide()
    addCommentToQuestionButton.show()

  appendCommentToQuestion = (data) ->
    commentsListForQuestions.append JST['templates/comment'](data)
