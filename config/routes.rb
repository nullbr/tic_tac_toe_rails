# frozen_string_literal: true

Rails.application.routes.draw do
  root 'games#index'

  resource :session, only: %i[new create]
  get 'signin' => 'sessions#new'
  get 'signout' => 'sessions#signout'

  resources :users, except: [:index]
  get 'signup' => 'users#new'

  resources :games, only: %i[index new create show] do
    post 'update_board' => 'games#update_board'
  end
end
