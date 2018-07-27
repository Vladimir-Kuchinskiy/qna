# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, dependent: :destroy

  belongs_to :user, optional: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  def can_operate?(current_user)
    user.present? && current_user == user
  end

  def give_vote(current_user, vote)
    if !can_vote?(current_user)
      false
    else
      ActiveModel::Type::Boolean.new.cast(vote) ? self.votes_count += 1 : self.votes_count -= 1
      current_user.vote(self)
      save
    end
  end

  private

  def can_vote?(current_user)
    current_user != user && !current_user.votes.find_by(question_id: id).try(:voted)
  end
end
