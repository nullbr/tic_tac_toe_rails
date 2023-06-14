# frozen_string_literal: true

Rails.application.routes.draw do
  root 'games#index'

  resource :session, only: %i[new create destroy]
  get 'signin' => 'sessions#new'

  resources :users
  get 'signup' => 'users#new'

  resources :games, only: [:index]
end
