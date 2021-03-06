# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'

  use_doorkeeper

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    match '/users/:id/verify_email', to: 'users/registrations#verify_email', via: %i[get patch], as: :verify_email
  end

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create] do
        resources :answers, shallow: true
      end
    end
  end

  concern :voteable do
    patch :vote,         on: :member
    patch :dismiss_vote, on: :member
  end

  concern :commentable do
    resources :comments, only: %i[create update destroy]
  end

  resources :questions, concerns: %i[voteable commentable], shallow: true do
    get 'search/*query/*type', to: 'questions#index', as: :search, on: :collection
    patch :subscribe,   on: :member
    patch :unsubscribe, on: :member
    resources :answers, concerns: %i[voteable commentable] do
      patch :pick_up_the_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :comments,    only: :create

  mount ActionCable.server => '/cable'

  authenticate :user, ->(user) { user.admin? } { mount Sidekiq::Web => '/sidekiq' }
end
