require 'rails_helper'

feature 'Add answer to a question', '
  In order to help with the solution
  As a user
  I want to be able to visit questions page
  And add an answer
' do

  given(:question) { create(:question) }
  given(:user)   { create(:user) }

  scenario 'Registered user tries to visit question page and add an answer' do
    sign_in(user)

    visit question_url(question)
    fill_in 'Body', with: 'Test Body'
    click_on 'Create Answer'

    expect(page).to have_content 'Answer was successfully created'
  end

  scenario 'Non-registered user tries to visit question page and add an answer' do

    visit question_url(question)
    fill_in 'Body', with: 'Test Body'
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
