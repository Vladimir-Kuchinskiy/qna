# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: create(:user)) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array questions
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'builds new attachment to @question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'builds new attachment to @answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect {
          post :create, params: { question: attributes_for(:question), format: :js }
        }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question), format: :js }
        expect(response).to render_template 'questions/create'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect {
          post :create, params: { question: attributes_for(:invalid_question), format: :js }
        }.to_not change(Question, :count)
      end

      it 'renders common/ajax_flash view' do
        post :create, params: { question: attributes_for(:invalid_question), format: :js }
        expect(response).to render_template 'common/ajax_flash'
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'user tries to update his answer' do
      context 'with valid attributes' do
        before do
          @user.questions << question
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        end
        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          question.reload
          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders update template' do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before do
          @user.questions << question
          patch :update, params: { id: question, question: attributes_for(:invalid_question), format: :js }
        end

        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 'renders update template' do
          expect(response).to render_template :update
        end
      end
    end

    context 'user tries to update another user\'s question' do
      before do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
      end

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 'renders common/flash ajax template' do
        expect(response).to render_template 'common/ajax_flash'
      end
    end
  end

  describe 'PATCH #vote' do
    sign_in_user
    context 'user tries to give' do
      context 'positive vote for question' do
        before { patch :vote, params: { id: question, vote: 1, format: :js } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question votes_count by +1' do
          expect(question.reload.votes_count).to eq 1
        end

        it 'renders vote template' do
          expect(response).to render_template :vote
        end
      end
      context 'negative vote for question' do
        before { patch :vote, params: { id: question, vote: -1, format: :js } }

        it 'assigns the requested question to @question' do
          expect(assigns(:question)).to eq question
        end

        it 'changes question votes_count by -1' do
          expect(question.reload.votes_count).to eq -1
        end

        it 'renders vote template' do
          expect(response).to render_template :vote
        end
      end
    end

    context 'author tries to give any vote' do
      before do
        question.update(user: @user)
        patch :vote, params: { id: question, vote: 1, format: :js }
      end
      it 'does not changes votes count of a question' do
        expect(question.reload.votes_count).to eq 0
      end
      it 'renders common/ajax_flash template' do
        expect(response).to render_template 'common/ajax_flash'
      end
    end
  end

  describe 'PATCH #dismiss_vote' do
    sign_in_user
    context 'Voted user tries to dismiss vote' do
      before do
        question.update(votes_count: 1)
        question.votes.create(user: @user, voted: true, choice: 1)
        patch :dismiss_vote, params: { id: question, format: :js }
      end

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question votes_count by -1' do
        expect(question.reload.votes_count).to eq 0
      end

      it 'gives user 1 chanse to vote for this question' do
        expect(@user.reload.votes.last.voted).to eq false
      end

      it 'renders vote template' do
        expect(response).to render_template :vote
      end
    end

    context 'User/Author tries to dismiss vote' do
      before { patch :dismiss_vote, params: { id: question, format: :js } }

      it 'do not change votes_count of question' do
        expect(question.reload.votes_count).to eq 0
      end

      it 'renders common/ajax_flash template' do
        expect(response).to render_template 'common/ajax_flash'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:another_question) { create(:another_question) }
    sign_in_user

    before do
      @user.questions << question
      another_question
    end

    context 'destroy user\'s question' do
      it 'removes a question record from the database' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions index path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'destroy another user\'s question' do
      it 'does not change questions count' do
        expect { delete :destroy, params: { id: another_question } }.to_not change(Question, :count)
      end

      it 'renders common/flash js template' do
        delete :destroy, params: { id: another_question }
        expect(response).to render_template 'common/ajax_flash'
      end
    end
  end
end
