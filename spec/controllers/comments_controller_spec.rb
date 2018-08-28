require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question, user: create(:user)) }
  let(:answer) { create(:answer, question: question, user: create(:user)) }

  describe 'POST #create' do
    context 'for question' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect {
            post :create, params: { comment: {
              body: 'New comment', commentable_id: question.id, commentable_type: 'Question'
            }, format: :js }
          }.to change(Comment, :count).by(1)
        end
        it 'renders create view' do
          post :create, params: { comment: {
            body: 'New comment', commentable_id: question.id, commentable_type: 'Question'
          }, format: :js }
          expect(response).to render_template 'comments/create'
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect {
            post :create, params: {
              comment: { body: nil, commentable_id: question.id, commentable_type: 'Question' },
              format: :js
            }
          }.to_not change(Comment, :count)
        end

        it 'renders common/ajax_flash view' do
          post :create, params: {
            comment: { body: nil, commentable_id: question.id, commentable_type: 'Question' },
            format: :js
          }
          expect(response).to render_template 'common/ajax_flash'
        end
      end
    end

    context 'for answer' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect {
            post :create, params: { comment: {
                body: 'New comment', commentable_id: answer.id, commentable_type: 'Answer'
            }, format: :js }
          }.to change(Comment, :count).by(1)
        end
        it 'renders create view' do
          post :create, params: { comment: {
              body: 'New comment', commentable_id: answer.id, commentable_type: 'Answer'
          }, format: :js }
          expect(response).to render_template 'comments/create'
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect {
            post :create, params: {
                comment: { body: nil, commentable_id: answer.id, commentable_type: 'Answer' },
                format: :js
            }
          }.to_not change(Comment, :count)
        end

        it 'renders common/ajax_flash view' do
          post :create, params: {
              comment: { body: nil, commentable_id: answer.id, commentable_type: 'Answer' },
              format: :js
          }
          expect(response).to render_template 'common/ajax_flash'
        end
      end
    end
  end
end
