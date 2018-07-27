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

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to a @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for a question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
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

      it 'redirects to question path' do
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'PATCH #vote' do
    sign_in_user
    context 'user tries to give' do
      context 'positive vote for question' do
        it 'assigns the requested question to @question' do
          patch :vote, params: { id: question, vote: true, format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'changes question votes_count by +1' do
          patch :vote, params: { id: question, vote: true, format: :js }
          expect(question.reload.votes_count).to eq 1
        end

        it 'renders vote template' do
          patch :vote, params: { id: question, vote: true, format: :js }
          expect(response).to render_template :vote
        end
      end
      context 'negative vote for question' do
        it 'assigns the requested question to @question' do
          patch :vote, params: { id: question, vote: false, format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'changes question votes_count by -1' do
          patch :vote, params: { id: question, vote: false, format: :js }
          expect(question.reload.votes_count).to eq -1
        end

        it 'renders vote template' do
          patch :vote, params: { id: question, vote: false, format: :js }
          expect(response).to render_template :vote
        end
      end
    end

    context 'author tries to give any vote' do
      before { question.update(user: @user) }
      it 'does not changes votes count of a question' do
        patch :vote, params: { id: question, vote: true, format: :js }
        expect(question.reload.votes_count).to eq 0
      end
      it 'renders vote template' do
        patch :vote, params: { id: question, vote: false, format: :js }
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

      it 're-renders questions index path' do
        delete :destroy, params: { id: another_question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
