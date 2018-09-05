# frozen_string_literal: true

require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
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
      let(:access_token) { create(:access_token) }

      it 'returns 200 status' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }
        expect(response).to be_success
      end
    end
  end
end