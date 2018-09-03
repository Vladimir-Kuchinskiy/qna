# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:facebook, :github],
         authentication_keys: { email: true }

  has_many :questions
  has_many :answers
  has_many :authorizations, dependent: :destroy
  has_many :votes,          dependent: :destroy
  has_many :comments,       dependent: :destroy

  validate :match_email, on: :update

  def vote(entity, voted)
    vote = votes.find_by(voteable_id: entity.id)
    return vote.update(voted: true, choice: voted) if vote
    votes.create(voteable_id: entity.id, voted: true, choice: voted)
  end

  def dismiss_vote(entity)
    vote = votes.find_by(voteable_id: entity.id)
    vote&.voted ? vote.update(voted: false, choice: 0) : false
  end

  def owner?(entity)
    entity.user_id == id
  end

  def can_vote?(entity)
    id != entity.user_id && !votes.find_by(voteable_id: entity.id).try(:voted)
  end

  def can_dismiss?(entity)
    id != entity.user_id && votes.find_by(voteable_id: entity.id)&.try(:voted)
  end

  class << self
    def find_for_oauth(auth)
      user = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s).try(:user)
      return user if user
      unless user = User.find_by(email: auth.info.email)
        password = Devise.friendly_token[0, 20]
        user = User.new(
          email: auth.info[:email] || "unverified-#{auth.uid}@#{auth.provider}.com",
          password: password, password_confirmation: password
        )
        user.skip_confirmation!
        user.save!
      end
      user.create_authorization(auth)
    end
  end

  def email_verified?
    !email.match(unverified_regexp)
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
    self
  end

  private

  def match_email
    errors.add(:email, 'Unverified') if email.match(unverified_regexp)
  end

  def unverified_regexp
    /^unverified-([a-z]|\d)+@(facebook|github).com$/i
  end
end
