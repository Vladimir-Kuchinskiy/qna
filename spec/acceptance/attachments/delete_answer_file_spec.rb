# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Delete file from question', '
  In order to remove files from question
  As an author of a question
  I would like to be able to delete files
' do

  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: create(:user)) }
  given!(:answer)   { create(:answer, user: user, attachments: [create(:attachment)], question: question) }

  describe 'Author' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'sees link for file delete' do
      within('.answers') { expect(page).to have_link 'Delete file' }
    end
    scenario 'tries to delete file from question', js: true do
      within('.answers') do
        click_on 'Delete file'
        expect(page).to_not have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
      end
      expect(page).to have_content 'Your file was successfully deleted'
    end
  end

  scenario 'Non-author tries to delete file from question' do
    sign_in(user)
    answer.update(user_id: create(:user).id)
    visit question_path(question)
    within('.answers') { expect(page).to_not have_link 'Delete file' }
  end
end
