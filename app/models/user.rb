# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy

  def vote(entity)
    if entity.is_a?(Question)
      votes.create(question_id: entity.id, voted: true)
    else
      votes.create(answer_id: entity.id, voted: true)
    end
  end
end
