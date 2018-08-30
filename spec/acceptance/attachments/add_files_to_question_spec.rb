require_relative '../acceptance_helper'

feature 'Add files to question', '
  In order to illustrate my question
  As an author of a question
  I would like to be able to attach files
' do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit questions_path
  end

  scenario 'User adds file when asks question', js: true do
    click_on 'Ask a Question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Question'

    expect(page).to have_content 'Your question was successfully created'
  end

  scenario 'User adds multiple files when asks question', js: true do
    click_on 'Ask a Question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    attach_file('File', "#{Rails.root}/spec/spec_helper.rb")
    click_on 'Add file'
    find(:xpath, '//*[@id="new_question"]/div[4]/div/input').set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create Question'

    expect(page).to have_content 'Your question was successfully created'
  end
end
