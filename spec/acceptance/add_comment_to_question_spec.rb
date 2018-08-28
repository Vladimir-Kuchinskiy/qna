require_relative 'acceptance_helper'

feature 'Add comment to question', '
  In order to discuss a question
  As an authenticated user
  I would like to be able to comment question
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: create(:user)) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to add a comment to the question', js: true do
      click_on 'add comment'
      fill_in 'Comment', with: 'Test comment'
      click_on 'Submit'

      within '.comments' do
        expect(page).to have_content 'Test comment'
      end
    end
  end

  describe 'Guest' do
    scenario 'tries to add a comment to the question', js: true do
      expect(page).to_not have_link 'add comment'
    end
  end
end
