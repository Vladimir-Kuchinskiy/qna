require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'sets a question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new Answer to a @question' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
end
