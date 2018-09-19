# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Search for a question by answer attributes', '
  In order to find question
  As a user
  I would like to be able to search for a question by its comments attributes
' do

  # given!(:questions)        { create_list(:question, 3, user: create(:user)) }
  # given!(:question)         { create(:question, title: 'My Title', user: create(:user)) }
  # given!(:answer)           { create(:answer, question: question, user: create(:user)) }
  # given!(:comment_question) { create(:comment, commentable: question, user: create(:user)) }
  # given!(:comment_answer)   { create(:comment, commentable: answer, user: create(:user)) }

  # before { visit questions_path }

  scenario 'User tries to find existed comment\'s question', sphinx: true do
    # fill_in 'Search', with: comment_question.body
    # select 'Comment', from: 'type'
    # form = find '.navbar-form'
    # class << form
    #   def submit!
    #     Capybara::RackTest::Form.new(driver, native).submit({})
    #   end
    # end
    # form.submit!
    # within('.questions_list') do
    #   expect(page).to have_content comment_question.commentable.title
    #   expect(page).to_not have_content questions.last.title
    # end
  end

  scenario 'User tries to find existed comment\'s answer\'s question', sphinx: true do
    # fill_in 'Search', with: comment_answer.body
    # select 'Comment', from: 'type'
    # form = find '.navbar-form'
    # class << form
    #   def submit!
    #     Capybara::RackTest::Form.new(driver, native).submit({})
    #   end
    # end
    # form.submit!
    # within('.questions_list') do
    #   expect(page).to have_content comment_answer.commentable.question.title
    #   expect(page).to_not have_content questions.last.title
    # end
  end

  scenario 'User tries to find non-existed answer\'s question', sphinx: true do
    # fill_in 'Search', with: 'non-existed comment'
    # select 'Comment', from: 'type'
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
