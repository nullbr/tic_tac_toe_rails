# frozen_string_literal: true

class Game < ApplicationRecord
  enum :mode, ['2 Players', 'Multiplayer', 'Player vs Computer', 'Computer vs Computer']
  enum :level, %w[Noobie Expert]

  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players, dependent: :destroy

  belongs_to :current_player, class_name: 'Player'

  after_create :set_current_player

  # returns false if input is invalid
  # return true and calls next player if valid
  def input_to_board(spot)
    return false unless spot_valid?(spot)

    board[spot.to_i] = current_player.symbol
    self.moves = moves + 1

    save

    # calls next player
    next_player

    true
  end

  private

  # checks who is current player and sets it to the other player
  def next_player
    player = current_player == players[0] ? players[1] : players[0]

    update(current_player: player)
  end

  # Check if spot is only a number, between 0 and 8 and not taken
  def spot_valid?(spot)
    /^\d$/.match?(spot) &&
      spot.to_i.between?(0, 8) &&
      !%w[X O].include?(board[spot.to_i])
  end

  def set_current_player
    first_player = players.select { |player| player.symbol == 'X' }

    update(current_player: first_player)
  end
end
