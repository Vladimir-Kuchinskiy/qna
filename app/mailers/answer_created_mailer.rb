# frozen_string_literal: true

class AnswerCreatedMailer < ApplicationMailer
  def notify(user, answer)
    @user = user
    @answer = answer
    mail to: user.email
  end
end
