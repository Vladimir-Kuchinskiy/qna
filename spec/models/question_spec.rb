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

  describe 'subscription' do
    let(:question) { build(:question, user: create(:user)) }

    it 'should create subscription for user after creating' do
      expect(question.subscriptions).to receive(:create).with(user: question.user)
      question.save!
    end

    it 'should not calculate reputation after update' do
      question.save!
      expect(question.subscriptions).to_not receive(:create)
      question.update(body: '123')
    end
  end

  let(:user)     { create(:user) }
  let(:question) { create(:question, user: create(:user)) }
  describe '#subscribe' do
    context 'for unsubscribed user' do
      it 'creates subscription' do
        expect { question.subscribe(user) }.to change(question.subscriptions, :count).by(1)
      end

      it 'returns question' do
        expect(question.subscribe(user)).to be_a(Question)
      end
    end

    context 'for subscribed user' do
      before { question.subscriptions.create(user: user) }

      it 'does not create subscription' do
        expect { question.subscribe(user) }.to_not change(question.subscriptions, :count)
      end

      it 'returns a cannot subscribe error' do
        question.subscribe(user)
        expect(question.errors[:user_id]).to_not be_blank
      end

      it 'returns question' do
        expect(question.subscribe(user)).to be_a(Question)
      end
    end
  end

  describe '#unsubscribe' do
    context 'for subscribed user' do
      before { question.subscriptions.create(user: user) }

      it 'destroys user subscription' do
        expect { question.unsubscribe(user) }.to change(question.subscriptions, :count).by(-1)
      end

      it 'returns question' do
        expect(question.unsubscribe(user)).to be_a(Question)
      end
    end

    context 'for unsubscribed user' do
      it 'does not destroy subscription' do
        expect { question.unsubscribe(user) }.to_not change(question.subscriptions, :count)
      end

      it 'returns a cannot unsubscribe error' do
        question.unsubscribe(user)
        expect(question.errors[:user_id]).to_not be_blank
      end

      it 'returns question' do
        expect(question.unsubscribe(user)).to be_a(Question)
      end
    end
  end
end
