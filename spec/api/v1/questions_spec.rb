# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API' do
  describe 'GET #me' do
    context 'Unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is not valid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let!(:questions) { create_list(:question, 3, user: create(:user)) }
      let!(:answer)    { create(:answer, question: question, user: create(:user)) }
      let(:access_token)     { create(:access_token, resource_owner_id: create(:user).id) }
      let(:question)         { questions.first }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns questions list' do
        expect(response.body).to have_json_size questions.count
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(questions.first.send(attr).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end
end