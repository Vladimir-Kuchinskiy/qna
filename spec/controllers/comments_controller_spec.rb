require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question, user: create(:user)) }
  let(:answer) { create(:answer, question: question, user: create(:user)) }

  describe 'POST #create' do
    context 'for question' do
      sign_in_user

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          post :create, params: { comment: { body: 'New comment' }, question_id: question.id, format: :js }
          expect(assigns(:commentable)).to eq question
        end

        it 'saves a new comment in the database' do
          expect do
            post :create, params: { comment: { body: 'New comment' }, question_id: question.id, format: :js }
          end.to change(Comment, :count).by(1)
        end
        it 'renders create view' do
          post :create, params: { comment: { body: 'New comment' }, question_id: question.id, format: :js }
          expect(response).to render_template 'comments/create'
        end
      end

      context 'with invalid attributes' do
        it 'assigns the requested question to @question' do
          post :create, params: { comment: { body: nil }, question_id: question.id, format: :js }
          expect(assigns(:commentable)).to eq question
        end

        it 'does not save the comment' do
          expect do
            post :create, params: { comment: { body: nil }, question_id: question.id, format: :js }
          end.to_not change(Comment, :count)
        end

        it 'renders create view' do
          post :create, params: { comment: { body: nil }, question_id: question.id, format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'for answer' do
      sign_in_user

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          post :create, params: { comment: { body: nil }, answer_id: answer.id, format: :js }
          expect(assigns(:commentable)).to eq answer
        end

        it 'saves a new comment in the database' do
          expect do
            post :create, params: { comment: { body: 'New comment' }, answer_id: answer.id, format: :js }
          end.to change(Comment, :count).by(1)
        end

        it 'renders create view' do
          post :create, params: { comment: { body: 'New comment' }, answer_id: answer.id, format: :js }
          expect(response).to render_template 'comments/create'
        end
      end

      context 'with invalid attributes' do
        it 'assigns the requested question to @question' do
          post :create, params: { comment: { body: nil }, answer_id: answer.id, format: :js }
          expect(assigns(:commentable)).to eq answer
        end

        it 'does not save the comment' do
          expect do
            post :create, params: { comment: { body: nil }, answer_id: answer.id, format: :js }
          end.to_not change(Comment, :count)
        end

        it 'renders create view' do
          post :create, params: { comment: { body: nil }, answer_id: answer.id, format: :js }
          expect(response).to render_template :create
        end
      end
    end
  end
end
