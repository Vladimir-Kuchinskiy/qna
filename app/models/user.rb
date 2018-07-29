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
    vote = votes.find_by(Kernel.eval("{ #{entity.class.name.downcase}_id: #{entity.id} }"))
    if vote
      vote.update(voted: true, choice: voted)
    else
      votes.create(Kernel.eval("{#{entity.class.name.downcase}_id: #{entity.id}, voted: true, choice: #{voted}}"))
    end
  end

  def dismiss_vote(entity)
    vote = votes.find_by(Kernel.eval("{ #{entity.class.name.downcase}_id: #{entity.id} }"))
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
