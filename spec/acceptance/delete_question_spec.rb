require 'rails_helper'

feature 'Delete question', '
  In order to delete my question if I need
  As an authenticated user
  I want to be able to delete my question
' do

  given(:user) { create(:user) { |user| user.questions << create_list(:question, 3) } }

  scenario 'Authenticated user tries to create a question' do
    sign_in(user)

    visit questions_path

    question_tr = find("tr[data-attr='#{user.questions.first.id}']")
    question_tr.find('a', text: 'Delete').click
    click_on 'OK'

    expect(page).to have_content 'Your question was successfully deleted'
  end

end
