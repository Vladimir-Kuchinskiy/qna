# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete answer', '
  In order to delete my answer if I need
  As an authenticated user
  I want to be able to delete my answer
' do
  
  given(:user)      { create(:user, answers: [create(:answer)]) }
  given!(:question) { create(:question, answers: user.answers + [create(:answer)]) }

  before do
    sign_in(user)
  end

  scenario 'Authenticated user tries to delete his own answers' do
    visit question_path(question)

    answer_tr = find("tr[data-answer='#{user.answers.first.id}']")
    answer_tr.find('a', text: 'Delete').click

    expect(page).to have_content 'Your answer was successfully deleted'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to delete someone else\'s question' do
    user.answers.destroy_all
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end
end
