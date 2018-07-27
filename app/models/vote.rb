class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  validates :voted, presence: true
end
