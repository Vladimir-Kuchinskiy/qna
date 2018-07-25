require_relative 'acceptance_helper'

feature 'Delete file from question', '
  In order to remove files from question
  As an author of a question
  I would like to be able to delete files
' do

  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: user, attachments: [create(:attachment)]) }

  describe 'Author' do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario 'sees link for file delete' do
      expect(page).to have_link 'Delete file'
    end
    scenario 'tries to delete file from question', js: true do
      click_on 'Delete file'
      expect(page).to have_content 'Your file was successfully deleted'
      expect(page).to_not have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    end
  end

  scenario 'Non-author tries to delete file from question' do
    sign_in(user)
    question.update(user_id: create(:user))
    visit question_path(question)
    expect(page).to_not have_link 'Delete file'
  end
end
