# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question, user: create(:user)) }

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
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
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
          patch :update, params: { id: answer, answer: { body: nil }, format: :js }
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
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
      end

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'MyText'
      end

      it 'renders common/ajax_flash template' do
        expect(response).to render_template 'common/ajax_flash'
      end
    end
  end

  describe 'PATCH #vote' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: create(:user)) }
    context 'user tries to give' do
      context 'positive vote for question' do
        before { patch :vote, params: { id: answer, vote: 1, format: :js } }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer votes_count by +1' do
          expect(answer.reload.votes_count).to eq 1
        end

        it 'renders vote template' do
          expect(response).to render_template :vote
        end
      end
      context 'negative vote for question' do
        before { patch :vote, params: { id: answer, vote: -1, format: :js } }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer votes_count by -1' do
          expect(answer.reload.votes_count).to eq(-1)
        end

        it 'renders vote template' do
          expect(response).to render_template :vote
        end
      end
    end

    context 'author tries to give any vote' do
      before do
        answer.update(user: @user)
        patch :vote, params: { id: answer, vote: 1, format: :js }
      end

      it 'does not changes votes count of an answer' do
        expect(answer.reload.votes_count).to eq(0)
      end

      it 'renders vote template' do
        expect(response).to render_template :vote
      end
    end
  end

  describe 'PATCH #dismiss_vote' do
    sign_in_user
    let(:answer) { create(:answer, question: question, user: create(:user)) }
    context 'Voted user tries to dismiss vote' do
      before do
        answer.update(votes_count: 1)
        answer.votes.create(user: @user, choice: 1)
        patch :dismiss_vote, params: { id: answer, format: :js }
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer votes_count by -1' do
        expect(answer.reload.votes_count).to eq(0)
      end
    end

    context 'User/Author tries to dismiss vote' do
      before { patch :dismiss_vote, params: { id: answer, format: :js } }

      it 'do not change votes_count of answer' do
        expect(answer.reload.votes_count).to eq(0)
      end

      it 'renders vote template' do
        expect(response).to render_template :vote
      end
    end
  end

  describe 'PATCH #pick_up_the_best' do
    sign_in_user
    let(:user)     { create(:user) }
    let(:question) { create(:question, user: user, answers: create_list(:answer, 3)) }
    before do
      question.answers.last.update(the_best: true)
      patch :pick_up_the_best, params: { id: question.answers.first }, format: :js
    end
    context 'tries to mark users\' answer as the best' do
      it 'assigns the requested answer to an @answer' do
        expect(assigns(:answer)).to eq question.answers.first
      end
      it 'changes the best attribute to the true' do
        question.answers.first.reload
        expect(question.answers.first.the_best).to eq true
      end
      it 'places the best answer as first of the answers collection' do
        question.answers.map(&:reload)
        expect(question.answers.from_the_best.first).to eq question.answers.first
      end
      it 'makes all the other answers\' the best attribute to nil' do
        question.answers.map(&:reload)
        expect(question.answers.map(&:the_best)).to eq [true, nil, nil]
      end
      it 'renders pick_up_the_best template' do
        expect(response).to render_template :pick_up_the_best
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'destroy another user\'s answer' do
      it 'does not change questions count' do
        expect { delete :destroy, params: { id: another_answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders common/ajax_flash template' do
        delete :destroy, params: { id: another_answer }, format: :js
        expect(response).to render_template 'common/ajax_flash'
      end
    end
  end
end
