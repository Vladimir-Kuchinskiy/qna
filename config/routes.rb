# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers do
      patch :pick_up_the_best, on: :member
    end
  end

  root to: 'questions#index'
end
