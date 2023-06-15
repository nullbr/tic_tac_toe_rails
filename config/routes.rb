# frozen_string_literal: true

Rails.application.routes.draw do
  root 'games#index'

  resource :session, only: %i[new create]
  get 'signin' => 'sessions#new'
  get 'signout' => 'sessions#signout'

  resources :users
  get 'signup' => 'users#new'

  resources :games, only: [:index]
end
