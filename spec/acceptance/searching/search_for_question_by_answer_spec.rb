require_relative '../acceptance_helper'

feature 'Search for a question by answer attributes', '
  In order to find question
  As a user
  I would like to be able to search for a question by its answers attributes
' do

  # given!(:questions) { create_list(:question, 3, user: create(:user)) }
  # given!(:question)  { create(:question, title: 'My Title', user: create(:user)) }
  # given!(:answer)    { create(:answer, question: question, user: create(:user)) }
  #
  # before { visit questions_path }

  scenario 'User tries to find existed answer\'s question' do
    # fill_in 'Search', with: answer.body
    # select 'Answer', from: 'type'
    # form = find '.navbar-form'
    # class << form
    #   def submit!
    #     Capybara::RackTest::Form.new(driver, native).submit({})
    #   end
    # end
    # form.submit!
    # within('.questions_list') do
    #   expect(page).to have_content answer.question.title
    #   expect(page).to_not have_content questions.last.title
    # end
  end

  scenario 'User tries to find non-existed answer\'s question' do
    # fill_in 'Search', with: 'non-existed question'
    # select 'Answer', from: 'type'
    # form = find '.navbar-form'
    # class << form
    #   def submit!
    #     Capybara::RackTest::Form.new(driver, native).submit({})
    #   end
    # end
    # form.submit!
    # within('.questions_list') do
    #   expect(page).to_not have_content 'non-existed question'
    #   expect(page).to_not have_content answer.question.title
    #   expect(page).to_not have_content questions.last.title
    # end
  end
end
