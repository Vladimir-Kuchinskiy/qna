require_relative 'acceptance_helper'

feature 'Add files to question', '
  In order to illustrate my question
  As an author of a question
  I would like to be able to attach files
' do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  # scenario 'User adds multiple files when asks question', js: true do
  #   fill_in 'Title', with: 'Test question'
  #   fill_in 'Body', with: 'text text text'
  #   attach_file('File', "#{Rails.root}/spec/spec_helper.rb")
  #   click_on 'Add file'
  #   find(:xpath, '//*[@id="new_question"]/div[4]/div/input').set("#{Rails.root}/spec/rails_helper.rb")
  #   click_on 'Create Question'
  #
  #   expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  #   expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/3/rails_helper.rb'
  # end
end
