# frozen_string_literal: true

class Question < ApplicationRecord
  include Voteable
  include ReputationCalculatable

  scope :from_last_day, -> { where('DATE(created_at) = ?', Time.zone.yesterday) }

  belongs_to :user, optional: true

  has_many :answers,                       dependent: :destroy
  has_many :attachments, as: :attachable,  dependent: :destroy
  has_many :comments, as: :commentable,    dependent: :destroy
  has_many :subscriptions,                 dependent: :destroy
  has_many :users, through: :subscriptions

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :update_reputation
  after_create :create_subscription

  def subscribe(user)
    if subscriptions.find_by(user_id: user.id).blank?
      subscriptions.create(user: user)
    else
      errors.add(:user_id, 'cannot subscribe')
    end
    self
  end

  def unsubscribe(user)
    if subscription = subscriptions.find_by(user_id: user.id)
      subscription.destroy
    else
      errors.add(:user_id, 'cannot unsubscribe')
    end
    self
  end

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end

  def create_subscription
    subscriptions.create(user: user)
  end
end
