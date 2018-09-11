class Ability
  include CanCan::Ability

  attr_accessor :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create,            [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer, Comment], user: user
    can :vote,              [Question, Answer]
    can :dismiss_vote,      [Question, Answer]
    can :subscribe, Question
    can :unsubscribe, Question
    can :pick_up_the_best, Answer
  end
end
