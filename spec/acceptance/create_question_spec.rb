require 'rails_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to create a question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask a Question'
    fill_in 'Title', with: 'Test Question'
    fill_in 'Body',  with: 'Test Body'
    click_on 'Create Question'

    expect(page).to have_content 'Your question was successfully created'
  end

  scenario 'Non-authenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask a Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
