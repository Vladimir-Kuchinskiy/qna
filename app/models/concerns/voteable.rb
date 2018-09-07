module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def give_vote(current_user, vote)
    if current_user.can_vote?(self)
      self.votes_count += vote if current_user.vote(self, vote)
      save
    else
      errors.add(:votes_count, 'access denied')
      self
    end
  end

  def remove_vote(current_user)
    if current_user.can_dismiss?(self)
      self.votes_count -= current_user.votes.find_by(voteable_id: id).choice
      current_user.dismiss_vote(self)
      save
    else
      errors.add(:votes_count, 'access denied')
      self
    end
  end
end