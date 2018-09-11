# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:attachments) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:subscriptions) }

  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  subject { create(:question, user: create(:user)) }
  it_behaves_like 'Voteable'

  subject { build(:question, user: create(:user)) }
  it_behaves_like 'ReputationCalculatable'

  let(:user)     { create(:user) }
  let(:question) { build(:question, user: user) }
  describe 'subscription' do
    it 'should create subscription for user after creating' do
      expect(question.subscriptions).to receive(:create).with(user: user)
      question.save!
    end

    it 'should not calculate reputation after update' do
      question.save!
      expect(question.subscriptions).to_not receive(:create)
      question.update(body: '123')
    end
  end
end
