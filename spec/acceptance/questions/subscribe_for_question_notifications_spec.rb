# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'Subscribe for question notifications', '
  In order to receive notifications about new answers of the question
  As a user
  I want to be able to subscribe for question notifications
' do

  given(:question) { create(:question, user: create(:user)) }
  given(:user)     { create(:user) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'tries to subscribe for a question notifications' do
      visit question_path(question)
      within('.body_question') { click_on 'Subscribe' }
      expect(page).to have_content('Your was successfully subscribed')
      within('.body_question') { expect(page).to have_link('Unsubscribe') }
    end

    scenario 'already subscribed tries to subscribe for a question notifications' do
      question.subscriptions.create(user: user)
      visit question_path(question)
      within('.body_question') { expect(page).to_not have_link('Subscribe') }
    end
  end

  describe 'Guest' do
    scenario 'tries to subscribe for question notifications' do
      visit question_path(question)
      within('.body_question') do
        expect(page).to_not have_link('Subscribe')
        expect(page).to_not have_link('Unsubscribe')
      end
    end
  end
end
