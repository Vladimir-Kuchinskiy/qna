# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:subscriptions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          expect(User.find_for_oauth(auth).authorizations.first.provider).to eq auth.provider
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@mail.com' }) }
        it 'creates a new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns a new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          expect(User.find_for_oauth(auth).email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          expect(User.find_for_oauth(auth).authorizations).to_not be_empty
        end

        it 'creates authorization with correct provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '#email_verified?' do
    let!(:user) { create(:user) }

    context 'user already verified the email' do
      it 'returns true' do
        expect(user.email_verified?).to eq true
      end
    end

    context 'user did not verified the email' do
      it 'returns false' do
        user.update(email: 'unverified-1231ss23@facebook.com')
        expect(user.email_verified?).to eq false
      end
    end
  end
end
