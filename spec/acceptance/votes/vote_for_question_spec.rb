# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Give a vote for a question', '
  In order to pick up the most useful/useless question
  As a user
  I would like to be able to give my vote
' do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User' do
    before do
      sign_in(user)
      visit questions_path
    end

    scenario 'tries to give a positive vote for a question', js: true do
      votes_count = question.votes_count
      within '.question' do
        click_on 'Like'
        within('.votes') { expect(page).to have_content((votes_count + 1).to_s) }
      end
      expect(page).to have_content 'Your vote was successfully added'
    end

    scenario 'tries to give a negative vote for a question', js: true do
      votes_count = question.votes_count
      within '.question' do
        click_on 'Dislike'
        within('.votes') { expect(page).to have_content((votes_count - 1).to_s) }
      end
      expect(page).to have_content 'Your vote was successfully added'
    end

    scenario 'tries to give more than 1 vote for a question', js: true do
      within '.question' do
        click_on 'Like'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end
  end

  describe 'Author' do
    scenario 'tries to give any vote for a question' do
      sign_in(author)
      visit questions_path
      within '.question' do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
      end
    end
  end
end
