# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Mark answer as the best', '
  In order to mark answer as in my opinion the most helpful
  As an authenticated user
  I want to be able to mark answer of my question as the best
' do

  given(:user)      { create(:user) }
  given!(:question) { create(:question, user: user, answers: create_list(:answer, 3, user: user)) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
    end

    scenario 'tries to mark answer as the best', js: true do
      visit question_path(question)

      find("#the-best-link-#{question.answers.last.id}").click

      expect(page).to have_content 'The answer was successfully marked as the best'
      within '.answers' do
        expect(find("div[data-answer='#{question.answers.last.id}']")).to have_content question.answers.last.body
      end
    end

    scenario 'tries to mark another answer as the best', js: true do
      question.answers.first.update(the_best: true)

      visit question_path(question)

      find("#the-best-link-#{question.answers.last.id}").click

      expect(page).to have_content 'The answer was successfully marked as the best'
      within '.answers' do
        expect(find("div[data-answer='#{question.answers.last.id}']")).to have_content question.answers.last.body
      end
    end
  end

  describe 'Non-authenticated user' do
    scenario 'tries to mark answer as the best' do
      visit question_path(question)

      expect(page).to_not have_selector("#the-best-link-#{question.answers.last.id}")
    end
  end
end
