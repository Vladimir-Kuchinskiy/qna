# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete answer', '
  In order to delete my answer if I need
  As an authenticated user
  I want to be able to delete my answer
' do

  given(:user) { create(:user) { |user| user.answers << create(:answer) } }
  given(:question) { create(:question) { |question| question.answers << create(:answer) << user.answers } }
  given(:another_question) { create(:another_question) { |question| question.answers << create(:answer) } }

  scenario 'Authenticated user tries to delete his own answers' do
    sign_in(user)

    visit question_path(question)

    answer_tr = find("tr[data-answer='#{user.answers.first.id}']")
    answer_tr.find('a', text: 'Delete').click

    expect(page).to have_content 'Your answer was successfully deleted'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to delete someone else\'s question' do
    sign_in(user)
    another_question
    visit question_path(another_question)

    answer_tr = find("tr[data-answer='#{another_question.answers.first.id}']")
    answer_tr.find('a', text: 'Delete').click

    expect(page).to have_content 'Sorry! You can delete only your own answers'
    expect(current_path).to eq question_path(another_question)
  end
end
