# frozen_string_literal: true

require_relative 'acceptance_helper'

feature 'Delete answer', '
  In order to delete my answer if I need
  As an authenticated user
  I want to be able to delete my answer
' do

  given(:user)      { create(:user) }
  given!(:answer)   { create(:answer, user: user) }
  given!(:question) { create(:question, answers: user.answers, user: user) }

  before do
    sign_in(user)
  end

  scenario 'Authenticated user tries to delete his own answers', js: true do
    visit question_path(question)

    within('.blog-post') { click_on 'Delete' }

    expect(page).to have_content 'Your answer was successfully deleted'

    within '.answers' do
      expect(page).to_not have_content 'MyText'
    end
  end

  scenario 'Authenticated user tries to delete someone else\'s question' do
    user.answers.destroy_all
    question.answers << create(:answer, user: create(:user))
    visit question_path(question)
    within('.answers') { expect(page).to_not have_link 'Delete' }
  end
end
