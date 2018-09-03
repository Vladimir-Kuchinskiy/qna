# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }

  devise_scope :user do
    match '/users/:id/verify_email', to: 'registrations#verify_email', via: %i[get patch], as: :verify_email
  end

  concern :voteable do
    patch :vote,         on: :member
    patch :dismiss_vote, on: :member
  end

  concern :commentable do
    resources :comments, only: %i[create update destroy]
  end

  resources :questions, concerns: %i[voteable commentable], shallow: true do
    resources :answers, concerns: %i[voteable commentable] do
      patch :pick_up_the_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :comments,    only: :create

  mount ActionCable.server => '/cable'
end
