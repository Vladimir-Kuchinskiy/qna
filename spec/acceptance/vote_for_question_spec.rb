require_relative 'acceptance_helper'

feature 'Give a vote for a question', '
  In order to pick up the most useful/useless question
  As a user
  I would like to be able to give my vote
' do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  background do
    sign_in(user)
    visit questions_path
  end

  describe 'User' do
    scenario 'tries to give a positive vote for a question'
    scenario 'tries to give a negative vote for a question'
  end

  describe 'Author' do
    scenario 'tries to give a positive vote for a question'
    scenario 'tries to give a negative vote for a question'
  end
end
