# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API' do
  describe 'GET #index' do
    context 'Unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/0/answers', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is not valid' do
        get '/api/v1/questions/0/answers', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let(:access_token)   { create(:access_token, resource_owner_id: create(:user).id) }
      let(:question)       { create(:question) }
      let!(:answers) { create_list(:answer, 3, question: question, user: create(:user)) }

      before do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns answers list' do
        expect(response.body).to have_json_size(answers.count).at_path('answers')
      end

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answers.first.send(attr).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    context 'Unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/answers/0', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is not valid' do
        get '/api/v1/answers/0', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'Authorized' do
      let!(:question)     { create(:question, user: create(:user)) }
      let!(:answer)       { create(:answer, question: question, user: create(:user)) }
      let!(:attachment)   { create(:attachment, attachable: answer) }
      let!(:comment)      { create(:comment, commentable: answer, user: create(:user)) }
      let!(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

      before do
        get "/api/v1/answers/#{answer.id}", params: {
          format: :json,
          access_token: access_token.token
        }
      end

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      %w[id body question_id user_id created_at updated_at].each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("answer/#{attr}")
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'contains file_url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('answer/attachments/0/file_url')
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w[id body commentable_id commentable_type user_id created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end
    end
  end
end