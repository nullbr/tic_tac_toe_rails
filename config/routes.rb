# frozen_string_literal: true

Rails.application.routes.draw do
  root 'activity#index'

  resource :session, only: %i[new create] do
    get 'create_guest'
  end
  get 'signin' => 'sessions#new'
  get 'signout' => 'sessions#signout'

  resources :users, except: [:index]
  get 'signup' => 'users#new'

  resources :games, only: %i[new create show] do
    resources :likes

    post 'update_board'
    get 'play_again'
  end

  get 'games/invite/:invitation_token', to: 'games#invite', as: 'game_invite'
end
