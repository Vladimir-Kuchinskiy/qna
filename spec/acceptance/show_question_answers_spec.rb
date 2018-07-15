require 'rails_helper'

feature "Show question with it's answers", '
  In order to to be aware of conversation about question topic
  As a guest
  I want to be able to see a question and it\'s answers
' do

  given(:answer) { create(:answer) }

  scenario 'User tries to see question and the answers' do
    byebug
    visit question_url(answer.question)

    expect(page).to have_content(answer.question.title)
    expect(page).to have_content(answer.question.body)
    expect(page).to have_content(answer.body)
  end

end