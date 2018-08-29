require_relative 'acceptance_helper'

feature 'Add comment to answer', '
  In order to discuss an answer
  As an authenticated user
  I would like to be able to comment answer
' do

  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: create(:user)) }
  given!(:answer)   { create(:answer, question: question, user: create(:user)) }

  scenario 'Authenticated user tries to add a comment to the answer', js: true do
    sign_in(user)
    visit question_path(question)

    within('.answers') do
      click_on 'add comment'
      fill_in 'Comment', with: 'Test comment for answer'
      click_on 'Create Comment'
    end

    within('.comments-for-answer') { expect(page).to have_content 'Test comment for answer' }
  end

  scenario 'Guest tries to add a comment to the answer', js: true do
    visit question_path(question)
    within('.answers') { expect(page).to_not have_link 'add comment' }
  end

  context 'Multiple sessions', js: true do
    scenario 'comment appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.answers') do
          click_on 'add comment'
          fill_in 'Comment', with: 'Test comment for answer'
          click_on 'Create Comment'
        end

        within('.comments-for-answer') { expect(page).to have_content 'Test comment for answer' }
      end

      Capybara.using_session('guest') do
        within('.comments-for-answer') { expect(page).to have_content 'Test comment for answer' }
      end
    end
  end
end
