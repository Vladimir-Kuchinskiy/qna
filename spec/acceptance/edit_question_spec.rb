require_relative 'acceptance_helper'

feature 'Edit question', '
  In order to make corrections in the question
  As an authenticated user
  I want to be able to edit a question
' do
  given(:user)              { create(:user) }
  given!(:question)         { create(:question, user: user) }
  given!(:another_question) { create(:another_question, user: create(:user)) }


  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'sees link to Edit' do
      visit question_path(question)
      within('.body_question') { expect(page).to have_link 'Edit' }
    end

    scenario 'tries to edit his question', js: true do
      visit question_path(question)
      within '.body_question' do
        click_on 'Edit'
        fill_in 'Title', with: 'new title'
        fill_in 'Body',  with: 'new body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'input'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit someone else\'s question' do
      visit question_path(another_question)
      within('.body_question') { expect(page).to_not have_link 'Edit' }
    end
  end

  describe 'None-authenticated user' do
    scenario 'tries to edit an answer' do
      visit question_path(question)
      within('.body_question') { expect(page).to_not have_link 'Edit' }
    end
  end
end
