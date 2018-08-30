require_relative '../acceptance_helper'

feature 'Dismiss a vote for a question', '
  In order cancel my vote for a question
  As a user
  I would like to be able to dismiss my vote
' do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, user: author, question: question) }

  describe 'User' do
    before { sign_in(user) }

    scenario 'tries to dismiss vote for a question', js: true do
      visit questions_path
      within '.question' do
        click_on 'Like'
        click_on 'Dismiss vote'
        within('.votes') { expect(page).to have_content('0') }
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
      end
      expect(page).to have_content 'Your vote was successfully dismissed'
    end

    scenario 'tries to dismiss vote for an answer', js: true do
      visit question_path(question)
      within '.answers' do
        click_on 'Like'
        click_on 'Dismiss vote'
        within('.answer-votes') { expect(page).to have_content('0') }
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
      end
      expect(page).to have_content 'Your vote was successfully dismissed'
    end
  end

  describe 'Author' do
    before do
      question.votes.create(user: author, voted: true, choice: 1)
      answer.votes.create(user: author, voted: true, choice: 1)
      sign_in(author)
    end

    scenario 'tries to dismiss vote for a question' do
      visit questions_path
      within('.question') { expect(page).to_not have_link 'Dismiss vote' }
    end

    scenario 'tries to dismiss vote for an answer' do
      visit question_path(question)
      within('.answers') { expect(page).to_not have_link 'Dismiss vote' }
    end
  end
end
