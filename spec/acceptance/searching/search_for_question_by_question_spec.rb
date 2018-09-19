# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Search for a question by question attributes', '
  In order to find question
  As a user
  I would like to be able to search for a question by its attributes
' do

  # given!(:question)  { create(:question, user: create(:user), title: 'My Title') }
  # given!(:questions) { create_list(:question, 3, user: create(:user)) }

  # before { visit questions_path }

  scenario 'User tries to find existed question', sphinx: true do
    # fill_in 'Search', with: question.title
    # form = find '.navbar-form'
    # class << form
    #   def submit!
    #     Capybara::RackTest::Form.new(driver, native).submit({})
    #   end
    # end
    # form.submit!
    # within('.questions_list') do
    #   expect(page).to have_content question.title
    #   expect(page).to_not have_content questions.first.title
    #   expect(page).to_not have_content questions.last.title
    # end
  end

  scenario 'User tries to find non-existed question', sphinx: true do
    # fill_in 'Search', with: 'non-existed question'
    # form = find '.navbar-form'
    # class << form
    #   def submit!
    #     Capybara::RackTest::Form.new(driver, native).submit({})
    #   end
    # end
    # form.submit!
    # within('.questions_list') do
    #   expect(page).to_not have_content 'non-existed question'
    #   expect(page).to_not have_content questions.first.title
    #   expect(page).to_not have_content questions.last.title
    # end
  end
end
