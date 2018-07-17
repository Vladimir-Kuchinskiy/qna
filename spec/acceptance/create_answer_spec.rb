require 'rails_helper'

feature 'Create answer', '
  In order to help community
  As an authenticated user
  I want to be able to add an answer
' do

  given(:question) { create(:question) }
  given(:user)     { create(:user) }

  scenario 'Authenticated user tries to create an answer' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create Answer'

    within 'tr' do
      expect(page).to have_content 'My answer'
    end

    expect(current_path).to eq question_path(question)
  end

end