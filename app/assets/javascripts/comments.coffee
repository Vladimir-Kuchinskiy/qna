# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready turbolinks:load', ->
  commentsListForQuestion = $('.comments-for-question')
  addCommentButton        = $('.add-comment')
  cancelComment           = $('.cancel-comment')

  addCommentButton.click (e) ->
    e.preventDefault()
    commentable_id = $(this).data('commentableId')
    $(this).hide()
    $("form[data-commentable-id='#{commentable_id}']").show()

  cancelComment.click (e) ->
    e.preventDefault()
    commentable_id = $(this).data('commentableId')
    $(".add-comment[data-commentable-id='#{commentable_id}']").show()
    $("form[data-commentable-id='#{commentable_id}']").hide()

  App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      appendComment(data)
  })

  appendComment = (data) ->
    switch data['comment']['commentable_type']
      when 'Answer' then $("div[data-answer-comments-id='#{data['comment']['commentable_id']}']").append JST['templates/comment'](data)
      when 'Question' then commentsListForQuestion.append JST['templates/comment'](data)
