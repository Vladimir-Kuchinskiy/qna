# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe '#question_id' do
    let(:question) { create(:question, user: create(:user)) }

    context 'for question comment' do
      it 'returns d of the question' do
        comment = create(:comment, commentable: question, user: create(:user))
        expect(comment.question_id).to eq question.id
      end
    end

    context 'for answer comment' do
      it 'returns question_id of the answer' do
        answer = create(:answer, user: create(:user), question: question)
        comment = create(:comment, commentable: answer, user: create(:user))
        expect(comment.question_id).to eq answer.question_id
      end
    end
  end
end
