# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Mark answer as the best', '
  In order to mark answer as in my opinion the most helpful
  As an authenticated user
  I want to be able to mark answer of my question as the best
' do

  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: user, answers: create_list(:answer, 2)) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'tries to mark answer as the best', js: true do
      visit question_path(question)

      find("a[data-best-answer-id='#{question.answers.last}']", text: 'Mark as the Best').click

      expect(page).to have_content 'Your answer was successfully marked as the best'
      within '.answers' do
        expect(find(:xpath, '//tr[1]/td[1]')).to have_content question.answers.last.body
      end
    end

    scenario 'tries to mark another answer as the best' do
      question.answers.last.update(the_best: true)

      visit question_path(question)

      find("a[data-best-answer-id='#{question.answers.first}']", text: 'Mark as the Best').click

      expect(page).to have_content 'Your answer was successfully marked as the best'
      within '.answers' do
        expect(find(:xpath, '//tr[1]/td[1]')).to have_content question.answers.first.body
      end
    end
  end

  describe 'Non-authenticated user'
end
