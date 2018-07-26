require_relative 'acceptance_helper'

feature 'Add files to answer', '
  In order to illustrate my answer
  As an author of an answer
  I would like to be able to attach files
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }


  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'Your answer', with: 'Test answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  # scenario 'User adds multiple files when asks question', js: true do
  #   fill_in 'Your answer', with: 'Test answer'
  #   attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
  #   click_on 'Add file'
  #   find(:xpath, '//*[@id="new_answer"]/div[3]/div/input').set("#{Rails.root}/spec/rails_helper.rb")
  #   click_on 'Create Answer'
  #
  #   within '.answers' do
  #     expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  #     expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  #   end
  # end
end
