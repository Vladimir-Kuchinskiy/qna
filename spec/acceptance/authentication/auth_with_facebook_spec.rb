# frozen_string_literal: true

require_relative '../acceptance_helper'

feature 'User sign in with Facebook', '
  In order to be able to ask question
  As a guest or authorized user
  I want to be able to sign in with Facebook
' do

  let!(:user) { create(:user) }

  scenario 'can sign in user with Facebook account' do
    visit new_user_session_path
    expect(page).to have_content 'Sign in with Facebook'
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'test@mail.com'
    expect(page).to have_content 'Sign out'
  end
end
