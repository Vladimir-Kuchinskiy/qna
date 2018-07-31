# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Create question', '
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
' do

  given(:user) { create(:user) }
  describe 'As a user' do
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
    end

    scenario 'can not create question with valid attributes' do
      click_on 'Ask a Question'
      fill_in 'Title', with: ''
      fill_in 'Body',  with: ''
      click_on 'Create Question'

      expect(page).to have_content 'Title can\'t be blank'
      expect(page).to have_content 'Body can\'t be blank'
    end
  end
end
