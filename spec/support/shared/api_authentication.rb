# frozen_string_literal: true

shared_examples_for 'API Authenticable' do
  context 'Unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is not valid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end
end
