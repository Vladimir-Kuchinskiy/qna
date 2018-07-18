# frozen_string_literal: true

require_relative 'acceptance_helper'

feature "Show question with it's answers", '
  In order to to be aware of conversation about question topic
  As a guest
  I want to be able to see a question and it\'s answers
' do

  given(:question) { create(:question) { |question| question.answers << create_list(:answer, 3) } }

  scenario 'User tries to see question and the answers' do
    visit question_url(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    question.answers.each { |answer| expect(page).to have_content(answer.body) }
  end
end
