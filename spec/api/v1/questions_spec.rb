# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    it_behaves_like 'API Authenticable'

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
        expect(response.body).to have_json_size(questions.count).at_path('questions')
      end

      %w[id title body user_id created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(questions.first.send(attr).to_json).at_path("questions/2/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/2/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path("questions/2/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      let!(:question)     { create(:question, user: create(:user)) }
      let!(:attachment)   { create(:attachment, attachable: question) }
      let!(:comment)      { create(:comment, commentable: question, user: create(:user)) }
      let!(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      %w[id title body user_id created_at updated_at].each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr).to_json).at_path("question/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('question/short_title')
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'contains file_url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/file_url')
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w[id body commentable_id commentable_type user_id created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions/0', params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like 'API Authenticable'

    context 'Authorized' do
      let!(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

      it 'returns 200 status code' do
        post '/api/v1/questions', params: {
          question: attributes_for(:question),
          format: :json,
          access_token: access_token.token
        }
        expect(response).to be_successful
      end

      it 'creates new question in the DB' do
        expect do
          post '/api/v1/questions', params: {
            question: attributes_for(:question),
            format: :json,
            access_token: access_token.token
          }
        end.to change(Question, :count)
      end
    end
  end

  def do_request(options = {})
    get '/api/v1/questions', params: { format: :json }.merge(options)
  end
end
