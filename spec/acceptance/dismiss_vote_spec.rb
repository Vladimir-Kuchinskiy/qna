require_relative 'acceptance_helper'

feature 'Dismiss a vote for a question', '
  In order cancel my vote for a question
  As a user
  I would like to be able to dismiss my vote
' do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User' do
    before do
      sign_in(user)
      visit questions_path
      within('.question') { click_on 'Like' }
    end

    scenario 'tries to dismiss vote for a question', js: true do
      within '.question' do
        click_on 'Dismiss vote'
        within('.votes') { expect(page).to have_content('0') }
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
      end
      expect(page).to have_content 'Your vote was successfully dismissed'
    end
  end
end
