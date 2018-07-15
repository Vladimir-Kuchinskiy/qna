require 'rails_helper'

feature 'Show questions list', '
  In order to see all questions
  As an guest
  I want to be able to visit questions page
' do

  given(:questions) { create_list(:question, 5) }

  scenario 'User tries to visit questions page with all the questions' do
    questions
    visit questions_path
    expect(page).to have_css('#questions_table tbody tr', count: 5)
  end

end
