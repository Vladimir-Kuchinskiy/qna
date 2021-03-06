# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'User sign in', '
  In order to be able to ask question
  As a user
  I want to be able to sign in
' do

  given(:user) { build(:user) }

  before do
    user.skip_confirmation!
    user.save!
  end

  scenario 'Registered user is tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in' do
    visit new_user_session_path
    fill_in 'Email',    with: 'fake@fake.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
