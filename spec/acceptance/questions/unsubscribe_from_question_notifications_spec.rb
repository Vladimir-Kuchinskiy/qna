# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Unsubscribe for question notifications', '
  In order to dismiss notifications about new answers of the question
  As a user
  I want to be able to unsubscribe from question notifications
' do

  given(:question) { create(:question, user: create(:user)) }
  given(:user)     { create(:user) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'tries to unsubscribe for a question notifications' do
      question.subscriptions.create(user: user)
      visit question_path(question)
      within('.body_question') { click_on 'Unsubscribe' }
      expect(page).to have_content('Your was successfully unsubscribed')
      within('.body_question') { expect(page).to have_link('Subscribe') }
    end

    scenario 'already unsubscribed tries to subscribe for a question notifications' do
      visit question_path(question)
      within('.body_question') { expect(page).to_not have_link('Unsubscribe') }
    end
  end

  describe 'Guest' do
    scenario 'tries to unsubscribe for question notifications' do
      visit question_path(question)
      within('.body_question') do
        expect(page).to_not have_link('Unsubscribe')
        expect(page).to_not have_link('Subscribe')
      end
    end
  end
end
