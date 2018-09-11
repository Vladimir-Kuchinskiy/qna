# frozen_string_literal: true

class NotifyQuestionUsersJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.users.each do |user|
      AnswerCreatedMailer.notify(user, answer).deliver_later
    end
  end
end
