# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:attachments) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }
  it { should validate_uniqueness_of(:the_best).scoped_to(:question_id) }

  it { should accept_nested_attributes_for :attachments }

  describe '#update_the_best' do
    let(:question) { create(:question, user: create(:user)) }
    let(:answer)   { create(:answer, user: create(:user), question: question) }

    it 'updates the_best attribute for the answer of the question' do
      answer.update_the_best
      expect(answer.the_best).to eq true
    end

    it 'assumes that the only one answer of the question is the best' do
      create_list(:answer, 3, question: question, user: create(:user))
      Answer.last.update(the_best: true)
      answer.update_the_best
      expect(question.answers.where(the_best: true).count).to eq 1
    end

    it 'returns the answer object' do
      expect(answer.update_the_best).to be_a(Answer)
    end
  end

  let(:question) { create(:question, user: create(:user)) }
  let(:answer)   { build(:answer, question: question, user: create(:user)) }
  describe 'questions notifications' do
    it 'should notify user after creating' do
      expect(NotifyQuestionUsersJob).to receive(:perform_later).with(answer)
      answer.save!
    end

    it 'should not calculate reputation after update' do
      answer.save!
      expect(NotifyQuestionUsersJob).to_not receive(:perform_later)
      answer.update(body: '123')
    end
  end

  subject { create(:answer, user: create(:user), question: create(:question, user: create(:user))) }
  it_behaves_like 'Voteable'

  subject { build(:answer, user: create(:user), question: create(:question, user: create(:user))) }
  it_behaves_like 'ReputationCalculatable'
end
