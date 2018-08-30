# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Delete question', '
  In order to delete my question if I need
  As an authenticated user
  I want to be able to delete my question
' do

  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_question) { create(:question, user: create(:user)) }

  before do
    sign_in(user)
  end

  scenario 'Authenticated user tries to delete his own question' do
    visit question_path(question)

    within('.body_question') { click_on 'Delete' }

    expect(page).to have_content 'Your question was successfully deleted'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete someone else\'s question' do
    visit question_path(another_question)
    expect(page).to_not have_link 'Delete'
  end
end
