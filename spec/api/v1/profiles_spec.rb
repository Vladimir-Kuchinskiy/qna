# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API' do
  describe 'GET #me' do
    context 'Unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is not valid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    describe 'Authorized' do
      let(:me)           { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      %w[id email created_at updated_at admin username].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #index' do
    context 'Unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is not valid' do
        get '/api/v1/profiles', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    describe 'Authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns users profiles list' do
        expect(response.body).to have_json_size(users.count)
        expect(response.body).to be_json_eql(users.to_json)
      end

      %w[password encrypted_password].each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end

        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end

      %w[id email created_at updated_at admin username].each do |attr|
        it "user object contains #{attr}" do
          expect(response.body).to be_json_eql(users.first.send(attr).to_json).at_path("0/#{attr}")
        end
      end
    end
  end
end