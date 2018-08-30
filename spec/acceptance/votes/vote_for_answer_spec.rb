require_relative '../acceptance_helper'

feature 'Give a vote for an answer', '
  In order to pick up the most useful/useless answer
  As a user
  I would like to be able to give my vote
' do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to give a positive vote for an answer', js: true do
      votes_count = answer.votes_count
      within '.answers' do
        click_on 'Like'
        within('.answer-votes') { expect(page).to have_content((votes_count + 1).to_s) }
      end
      expect(page).to have_content 'Your vote was successfully added'
    end

    scenario 'tries to give a negative vote for an answer', js: true do
      votes_count = question.votes_count
      within '.answers' do
        click_on 'Dislike'
        within('.answer-votes') { expect(page).to have_content((votes_count - 1).to_s) }
      end
      expect(page).to have_content 'Your vote was successfully added'
    end

    scenario 'tries to give more than 1 vote for a question', js: true do
      within '.answers' do
        click_on 'Like'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end
  end

  describe 'Author' do
    scenario 'tries to give any vote for an aswer' do
      sign_in(author)
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end
  end
end
