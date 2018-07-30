class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true, optional: true

  validates :choice, presence: true
end
