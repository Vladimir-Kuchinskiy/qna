require 'rails_helper'

RSpec.describe NotifyQuestionUsersJob, type: :job do
  let(:question) { create(:question, user: create(:user)) }
  let(:answer)   { create(:answer, question: question, user: create(:user)) }
  let(:users)    { create_list(:user, 2) }
  before { users.each { |user| question.subscriptions.create(user: user) } }

  it 'should send notification when answer created to all users subscribed on the answer\'s question' do
    question.users.each { |user| expect(AnswerCreatedMailer).to receive(:notify).with(user, answer).and_call_original }
    NotifyQuestionUsersJob.perform_now(answer)
  end
end
