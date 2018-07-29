# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers
  has_many :votes, dependent: :destroy

  def vote(entity)
    if entity.is_a?(Question)
      votes.create(question_id: entity.id, voted: true)
    else
      votes.create(answer_id: entity.id, voted: true)
    end
  end

  def owner?(entity)
    entity.user == self
  end

  def can_vote?(entity)
    if entity.is_a?(Question)
      self != entity.user && !self.votes.find_by(question_id: entity.id).try(:voted)
    else
      self != entity.user && !self.votes.find_by(answer_id: entity.id).try(:voted)
    end
  end
end
