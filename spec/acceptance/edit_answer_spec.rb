require_relative 'acceptance_helper'

feature 'Edit answer', '
  In order to make corrections in the answer
  As an authenticated user
  I want to be able to edit an answer
' do
  given(:question) { create(:question) }
  given(:answer)   { create(:answer, question: question) }
  given(:user)     { create(:user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'sees link to Edit' do
      within '.answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his answer'

    scenario 'tries to edit someone else\'s answer'
  end

  scenario 'Non-authenticated user tries to edit an answer' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Edit'
  end
end