# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        end.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        end.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:answer) { create(:answer, question: question) }
    context 'user tries to update his answer' do
      context 'with valid attributes' do
        before do
          @user.answers << answer
          patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
        end
        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update template' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before do
          @user.answers << answer
          patch :update, params: { id: answer, question_id: question, answer: { body: nil }, format: :js }
        end

        it 'does not change answer attributes' do
          answer.reload
          expect(answer.body).to eq 'MyText'
        end

        it 'renders update template' do
          expect(response).to render_template :update
        end
      end
    end

    context 'user tries to update another user\'s answer' do
      before do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
      end

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 'redirects to question path' do
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #pick_the_best' do
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user, answers: create_list(:answer, 2)) }
    sign_in_user
    before do
      patch :pick_the_best, params: { id: question.answers.first, question_id: question, answer: { the_best: true }, format: :js }
    end
    context 'tries to mark users\' answer as the best' do
      it 'assigns the requested answer to an @answer' do
        expect(assigns(:answer)).to eq question.answers.first
      end
      it 'changes the best attribute to the true' do
        question.answers.first.reload
        expect(question.answers.first.the_best).to eq true
      end
      it 'makes all the other answers\' the best attribute to false' do
        expect((question.answers[-1] + question.answers[-2]).map(&:the_best)).to eq [false, false]
      end
    end
  end


  describe 'DELETE #destroy' do
    let(:answer)         { create(:answer) }
    let(:another_answer) { create(:another_answer) }
    sign_in_user

    before do
      question.answers << answer << another_answer
      @user.answers << answer
    end

    context 'destroy user\'s answer' do
      it 'removes an answer record from the database' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'destroy another user\'s answer' do
      it 'does not change questions count' do
        expect { delete :destroy, params: { id: another_answer, question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to questions/show path' do
        delete :destroy, params: { id: another_answer, question_id: question }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
