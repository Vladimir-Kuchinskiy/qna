# frozen_string_literal: true

class Question < ApplicationRecord
  include Voteable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  belongs_to :user, optional: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :calculate_reputation

  private

  def calculate_reputation
    user.update(reputation: Reputation.calculate(self))
  end
end
