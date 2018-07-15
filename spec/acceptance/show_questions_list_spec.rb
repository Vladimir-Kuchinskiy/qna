require 'rails_helper'

feature 'Show questions list', %q{
  In order to see all questions
  As an guest
  I want to be able to visit questions page
} do

  given(:questions) { create_list(:question, 5) }

  scenario 'User tries to visit questions page with all the questions' do
    questions
    visit questions_path
    expect(page).to have_xpath("//table[@id='questions_table']")
    expect(page).to have_css('table#questions_table tbody tr', count: 5)
  end

end
