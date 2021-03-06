# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)       { create(:user) }
    let(:other_user) { create(:user) }
    let(:question)   { create(:question, user: user) }
    let(:answer)     { create(:answer, user: user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

    it { should be_able_to :update, create(:comment, user: user, commentable: create(:question)), user: user }
    it { should_not be_able_to :update, create(:comment, user: other_user, commentable: create(:answer)), user: user }

    it { should be_able_to :destroy, create(:question, user: user), user: user }
    it { should_not be_able_to :destroy, create(:question, user: other_user), user: user }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }

    it { should be_able_to :destroy, create(:comment, user: user, commentable: question), user: user }
    it { should_not be_able_to :destroy, create(:comment, user: other_user, commentable: answer), user: user }

    it { should be_able_to :vote, Question }
    it { should be_able_to :dismiss_vote, Question }
    it { should be_able_to :vote, Answer }
    it { should be_able_to :dismiss_vote, Answer }
    it { should be_able_to :pick_up_the_best, Answer }
  end
end
