# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete question', '
  In order to delete my question if I need
  As an authenticated user
  I want to be able to delete my question
' do

  given(:user) { create(:user) { |user| user.questions << create_list(:question, 3) } }
  given(:question) { create(:question) }

  scenario 'Authenticated user tries to delete his own question' do
    sign_in(user)

    visit questions_path

    question_tr = find("tr[data-attr='#{user.questions.first.id}']")
    question_tr.find('a', text: 'Delete').click

    expect(page).to have_content 'Your question was successfully deleted'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete someone else\'s question' do
    sign_in(user)
    question
    visit questions_path

    question_tr = find("tr[data-attr='#{question.id}']")
    question_tr.find('a', text: 'Delete').click

    expect(page).to have_content 'Sorry! You can delete only your own questions'
    expect(current_path).to eq questions_path
  end
end
