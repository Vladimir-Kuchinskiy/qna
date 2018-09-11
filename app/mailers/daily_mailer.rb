# frozen_string_literal: true

class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.from_last_day
    mail to: user.email
  end
end
