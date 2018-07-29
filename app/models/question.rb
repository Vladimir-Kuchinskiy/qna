# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, dependent: :destroy

  belongs_to :user, optional: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  def give_vote(current_user, vote)
    if current_user.can_vote?(self)
      self.votes_count += vote
      current_user.vote(self, vote)
      save
    else
      false
    end
  end

  def remove_vote(current_user)
    if current_user.can_dismiss?(self)
      self.votes_count -= current_user.votes.find_by(question_id: id).choice
      current_user.dismiss_vote(self)
      save
    else
      false
    end
  end
end
