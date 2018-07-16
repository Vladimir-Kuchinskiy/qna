require 'rails_helper'

feature 'User sign in', '
  In order to be able to ask question
  As a user
  I want to be able to sign in
' do

  given(:user) { create(:user) }

  scenario 'Signed out user tries to sign out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end

end
