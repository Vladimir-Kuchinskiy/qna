# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'User sign in with Github', '
  In order to be able to ask question
  As a guest or authorized user
  I want to be able to sign in with Github
' do

  let!(:user) { build(:user) }

  context 'Authorized user' do
    before do
      user.skip_confirmation!
      user.save!
      user.authorizations.create(uid: '12345621412', provider: 'github')
    end

    scenario 'can sign in user with GitHub account' do
      visit new_user_session_path
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from GitHub account'
      expect(page).to have_content 'Sign out'
    end
  end

  context 'Unverified user' do
    scenario 'can sign in user with GitHub account' do
      visit new_user_session_path
      click_on 'Sign in with GitHub'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_on 'Send Confirmation'
      open_email(user.email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
      expect(page).to have_content 'Signed in successfully.'
      expect(current_path).to eq root_path
    end
  end
end
