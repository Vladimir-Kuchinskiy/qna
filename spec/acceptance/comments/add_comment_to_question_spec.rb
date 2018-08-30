require_relative 'acceptance_helper'

feature 'Add comment to question', '
  In order to discuss a question
  As an authenticated user
  I would like to be able to comment question
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: create(:user)) }

  scenario 'Authenticated user tries to add a comment to the question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'add comment'
    fill_in 'Comment', with: 'Test comment for question'
    click_on 'Create Comment'

    within('.comments-for-question') { expect(page).to have_content 'Test comment for question' }
  end

  scenario 'Guest tries to add a comment to the question', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'add comment'
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
        click_on 'add comment'
        fill_in 'Comment', with: 'Test comment for question'
        click_on 'Create Comment'

        within '.comments-for-question' do
          expect(page).to have_content 'Test comment for question'
        end
      end

      Capybara.using_session('guest') do
        within '.comments-for-question' do
          expect(page).to have_content 'Test comment for question'
        end
      end
    end
  end
end
