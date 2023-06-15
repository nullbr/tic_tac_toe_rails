# frozen_string_literal: true

class Game < ApplicationRecord
  enum :mode, ['2 Players', 'Multiplayer', 'Player vs Computer', 'Computer vs Computer']
  enum :level, %w[Noobie Expert]

  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games, dependent: :destroy
end
