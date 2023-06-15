# frozen_string_literal: true

class Game < ApplicationRecord
  enum :mode, ['2 Players', 'Multiplayer', 'Player vs Computer', 'Computer vs Computer']
  enum :level, %w[Noobie Expert]

  has_many :user_games, dependent: :destroy
  has_many :users, through: :user_games, dependent: :destroy

  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players, dependent: :destroy

  # returns false if input is invalid
  # return true and calls next player if valid
  def input_to_board(spot)
    return false unless spot_valid?(spot)

    board[spot] = @current_player.symbol

    @moves += 1

    # calls next player
    next_player

    true
  end

  private

  # Check if spot is only a number, between 0 and 8 and not taken
  def spot_valid?(spot)
    /^\d$/.match?(spot) &&
      spot.to_i.between?(0, 8) &&
      !%w[X O].include?(board[spot.to_i])
  end
end
