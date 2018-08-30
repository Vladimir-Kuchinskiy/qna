# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:attachment_question) { create(:attachment, attachable: create(:question)) }
  let!(:attachment_answer)   { create(:attachment, attachable: create(:answer, question: create(:question))) }
  describe 'DELETE #destroy' do
    sign_in_user

    context 'destroy question attachment' do
      context 'by author' do
        before { @user.questions << attachment_question.attachable }
        it 'assigns the requested attachment to @attachment' do
          delete :destroy, params: { id: attachment_question }, format: :js
          expect(assigns(:attachment)).to eq attachment_question
        end

        it 'removes an attachment record from the database' do
          expect { delete :destroy, params: { id: attachment_question }, format: :js }.to change(Attachment, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: attachment_question }, format: :js
          expect(response).to render_template :destroy
        end
      end
      context 'non-author' do
        before { @user.questions.map { |q| q.update(user_id: nil) } }
        it 'does not change attachments count' do
          expect { delete :destroy, params: { id: attachment_question }, format: :js }.to_not change(Attachment, :count)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: attachment_question }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'destroy answer attachment' do
      context 'by author' do
        before { @user.answers << attachment_answer.attachable }
        it 'assigns the requested attachment to @attachment' do
          delete :destroy, params: { id: attachment_answer }, format: :js
          expect(assigns(:attachment)).to eq attachment_answer
        end

        it 'removes an attachment record from the database' do
          expect { delete :destroy, params: { id: attachment_answer }, format: :js }.to change(Attachment, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: attachment_answer }, format: :js
          expect(response).to render_template :destroy
        end
      end
      context 'non-author' do
        before { @user.answers.map { |a| a.update(user_id: nil) } }
        it 'does not change attachments count' do
          expect { delete :destroy, params: { id: attachment_answer }, format: :js }.to_not change(Attachment, :count)
        end

        it 'renders destroy template' do
          delete :destroy, params: { id: attachment_answer }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

  end
end
