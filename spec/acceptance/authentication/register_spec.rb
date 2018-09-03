# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'User sign up', '
  In order to be able to ask question
  As a guest
  I want to be able to sign up
' do

  given(:user) { build(:user) }

  scenario 'Non-registered user tries to register' do
    visit new_user_registration_url

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'
    open_email(user.email)
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'User tries to register with a taken email' do
    user.skip_confirmation!
    user.save!
    visit new_user_registration_url

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq user_registration_path
  end
end
