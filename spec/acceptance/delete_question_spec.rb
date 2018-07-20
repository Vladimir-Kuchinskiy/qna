# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete question', '
  In order to delete my question if I need
  As an authenticated user
  I want to be able to delete my question
' do

  given(:user)      { create(:user, questions: create_list(:question, 3)) }
  given!(:question) { create(:question) }

  before do
    sign_in(user)
  end

  scenario 'Authenticated user tries to delete his own question' do
    visit questions_path

    question_tr = find("tr[data-attr='#{user.questions.first.id}']")
    question_tr.find('a', text: 'Delete').click

    expect(page).to have_content 'Your question was successfully deleted'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete someone else\'s question' do
    user.questions.destroy_all
    visit questions_path
    expect(page).to_not have_link 'Delete'
  end
end
