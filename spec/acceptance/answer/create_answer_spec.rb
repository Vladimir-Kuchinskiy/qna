require_relative '../acceptance_helper'

feature 'Create answer', '
  In order to help community
  As an authenticated user
  I want to be able to add an answer
' do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  before do
    sign_in(user)
  end

  scenario 'Authenticated user tries to create an answer', js: true do
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create Answer'

    within '.answers' do
      expect(page).to have_content 'My answer'
    end

    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to create invalid answer', js: true do
    visit question_path(question)

    click_on 'Create Answer'

    expect(page).to have_content 'Invalid answer'
    expect(page).to have_content 'Body can\'t be blank'
    expect(current_path).to eq question_path(question)
  end

  context 'Multiple sessions', js: true do
    scenario 'answer appears on another user\'s page' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'My answer'
        click_on 'Create Answer'

        within('.answers') { expect(page).to have_content 'My answer' }
      end

      Capybara.using_session('guest') do
        within('.answers') { expect(page).to have_content 'My answer' }
      end
    end
  end

end