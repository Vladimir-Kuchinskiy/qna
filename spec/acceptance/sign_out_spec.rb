# frozen_string_literal: true

require 'rails_helper'

feature 'User sign out', '
  In order to be able to quit the system
  As a user
  I want to be able to sign out
' do

  given(:user) { create(:user) }

  scenario 'Signed out user tries to sign out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
