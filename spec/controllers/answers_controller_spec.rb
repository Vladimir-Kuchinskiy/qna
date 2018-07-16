require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer)   { create(:answer) }

  describe 'GET #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to a questions#show view'do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        end.to_not change(Answer, :count)
      end

      it 're-renders questions/show view' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_answer) { create(:another_answer) }
    sign_in_user

    before do
      question.answers << answer << another_answer
      @user.answers << answer
    end

    context 'destroy user\'s answer' do
      it 'removes an answer record from the database' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question path' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'destroy another user\'s answer' do
      it 'does not change questions count' do
        expect { delete :destroy, params: { id: another_answer } }.to_not change(Answer, :count)
      end

      it 're-renders questions/show path' do
        delete :destroy, params: { id: another_answer }
        expect(response).to redirect_to question_path(question)
      end
    end

  end
end
