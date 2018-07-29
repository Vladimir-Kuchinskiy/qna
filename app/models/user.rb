# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers
  has_many :votes, dependent: :destroy

  def vote(entity, voted)
    if entity.is_a?(Question)
      vote = votes.find_by(question_id: entity.id)
      vote ? vote.update(voted: true, choice: voted) : votes.create(question_id: entity.id, voted: true, choice: voted)
    else
      vote = votes.find_by(answer_id: entity.id)
      vote ? vote.update(voted: true, choice: voted) : votes.create(answer_id: entity.id, voted: true, choice: voted)
    end
  end

  def dismiss_vote(entity)
    vote = entity.is_a?(Question) ? votes.find_by(question_id: entity.id) : votes.find_by(answer_id: entity.id)
    vote&.voted ? vote.update(voted: false, choice: 0) : false
  end

  def owner?(entity)
    entity.user == self
  end

  def can_vote?(entity)
    if entity.is_a?(Question)
      self != entity.user && !votes.find_by(question_id: entity.id).try(:voted)
    else
      self != entity.user && !votes.find_by(answer_id: entity.id).try(:voted)
    end
  end

  def can_dismiss?(entity)
    if entity.is_a?(Question)
      self != entity.user && votes.find_by(question_id: entity.id)&.try(:voted)
    else
      self != entity.user && votes.find_by(answer_id: entity.id)&.try(:voted)
    end
  end
end
