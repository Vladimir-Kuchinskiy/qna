require 'rails_helper'

feature 'Delete question', '
  In order to delete my question if I need
  As an authenticated user
  I want to be able to delete my question
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to create a question' do
    sign_in(user)

    visit questions_path

    question_tr = find("tr[data-attr='#{user.questions.first.id}']")
    question_tr.find('a', text: 'Delete').click
    click_on 'OK'

    expect(page).to have_content 'Your question was successfully deleted'
  end

  scenario 'Non-authenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask a Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
