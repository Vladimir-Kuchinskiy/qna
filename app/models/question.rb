# frozen_string_literal: true

class Question < ApplicationRecord
  include Voteable
  include ReputationCalculatable

  scope :from_last_day, -> { where('DATE(created_at) = ?', Time.zone.yesterday) }

  belongs_to :user, optional: true

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :update_reputation

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
