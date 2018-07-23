# frozen_string_literal: true

class Question < ApplicationRecord
  has_many   :answers
  has_many   :attachments, as: :attachable

  belongs_to :user, optional: true

  accepts_nested_attributes_for :attachments

  validates :title, :body, presence: true

  def can_operate?(current_user)
    user.present? && current_user == user
  end
end
