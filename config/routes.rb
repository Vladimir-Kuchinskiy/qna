# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    patch :vote,         on: :member
    patch :dismiss_vote, on: :member
    resources :answers do
      patch :pick_up_the_best, on: :member
      patch :dismiss_vote,     on: :member
      patch :vote,             on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :comments,    only: :create


  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
