require_relative 'acceptance_helper'

feature 'Edit answer', '
  In order to make corrections in the answer
  As an authenticated user
  I want to be able to edit an answer
' do
  given(:user)             { create(:user) }
  given(:question)         { create(:question) }
  given(:answer)           { create(:answer, question: question) }

  describe 'Authenticated user' do
    before do
      user.answers << answer
      sign_in(user)
    end

    scenario 'sees link to Edit' do
      visit question_path(question)
      within('.answers') { expect(page).to have_link 'Edit' }
    end

    scenario 'tries to edit his answer', js: true do
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit someone else\'s answer' do
      user.answers.destroy_all
      visit question_path(question)
      within('.answers') { expect(page).to_not have_link 'Edit' }
    end
  end

  scenario 'Non-authenticated user tries to edit an answer' do
    visit question_path(question)
    within('.answers') { expect(page).to_not have_link 'Edit' }
  end
end
