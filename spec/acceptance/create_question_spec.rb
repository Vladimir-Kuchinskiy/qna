# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
' do

  given(:user) { create(:user) }

  context 'As a user', js: true do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'creates question with valid attributes' do
      click_on 'Ask a Question'
      fill_in 'Title', with: 'Test Question'
      fill_in 'Body',  with: 'Test Body'
      click_on 'Create Question'

      expect(page).to have_content 'Your question was successfully created'
      expect(page).to have_content 'Test Question'
      expect(page).to have_content 'Test Body'
    end

    scenario 'can not create question with valid attributes' do
      click_on 'Ask a Question'
      fill_in 'Title', with: ''
      fill_in 'Body',  with: ''
      click_on 'Create Question'

      expect(page).to have_content 'Invalid question'
    end
  end

  context 'Multiple sessions', js: true do
    scenario 'question appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask a Question'
        fill_in 'Title', with: 'Test Question'
        fill_in 'Body',  with: 'Test Body'
        click_on 'Create Question'

        expect(page).to have_content 'Test Question'
        expect(page).to have_content 'Test Body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test Question'
        expect(page).to have_content 'Test Body'
      end
    end
  end

  context 'As a guest' do
    scenario 'can not create question' do
      visit questions_path
      expect(page).to_not have_link 'Ask a Question'
    end
  end
end
