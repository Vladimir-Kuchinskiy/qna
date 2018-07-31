# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
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

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
