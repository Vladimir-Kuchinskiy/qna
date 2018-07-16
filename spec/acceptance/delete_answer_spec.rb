require 'rails_helper'

feature 'Delete answer', '
  In order to delete my answer if I need
  As an authenticated user
  I want to be able to delete my answer
' do

  given(:user) { create(:user) { |user| user.answers << create(:answer) } }
  given(:answer) { create(:answer) }
  given(:question) { create(:question) { |question| question.answers << answer << user.answers } }



  scenario 'Authenticated user tries to delete his own answers' do
    sign_in(user)

    visit question_path(question)

    question_tr = find("tr[data-answer='#{user.answers.first.id}']")
    question_tr.find('a', text: 'Delete').click

    expect(page).to have_content 'Your answer was successfully deleted'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to delete someone else\'s question' do
    sign_in(user)
    question
    visit questions_path

    question_tr = find("tr[data-attr='#{answer.id}']")
    question_tr.find('a', text: 'Delete').click

    expect(page).to have_content 'Sorry! You can delete only your own questions'
    expect(current_path).to eq questions_path
  end

end
