# frozen_string_literal: true

require 'securerandom'

class Game < ApplicationRecord
  include ActionView::RecordIdentifier
  include GamesHelper

  enum :mode, ['2 Players', 'Online', 'Player vs Computer', 'Computer vs Computer']
  enum :level, %w[Noobie Expert]

  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players, dependent: :destroy

  belongs_to :current_player, class_name: 'Player', optional: true

  after_create :generate_invitation_token
  after_update_commit lambda {
    broadcast_update_later_to 'game',
                              target: dom_id(self),
                              partial: 'games/game',
                              locals: { game: self, win_pattern: win_pattern(self) }
  }

  # Determine the possible types of game finish
  FINISH_TYPES = [
    { patterns: [[0, 4, 8], [2, 4, 6]], name: 'Diagonal' },
    { patterns: [[0, 3, 6], [1, 4, 7], [2, 5, 8]], name: 'Vertical' },
    { patterns: [[0, 1, 2], [3, 4, 5], [6, 7, 8]], name: 'Horizontal' }
  ].freeze

  # returns false if input is invalid
  # return true and calls next player if valid
  def input_to_board(spot)
    return false unless spot_valid?(spot) && win_type.nil?

    board[spot.to_i] = game_players.find_by(player: current_player).symbol
    self.moves = moves + 1

    save

    # calls next player
    next_player unless game_over?

    true
  end

  # Checks all game possibilities and returns true if game won or false if not
  def game_over?
    return true unless win_type.nil?

    if (type = check_patterns)
      update(win_type: type, end_at: Time.zone.now)
    elsif moves == 9
      update(win_type: { pattern: [], name: 'Tie', end_at: Time.zone.now }.to_json)
    end

    !win_type.nil?
  end

  private

  # generate invitation token for invited player access
  def generate_invitation_token
    # return unless game mode is online
    return unless Game.modes[mode] == 1

    update(invitation_token: SecureRandom.urlsafe_base64)
  end

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

  # Iterate over each finish type pattern and return finish type if any
  def check_patterns
    finish_type = nil

    FINISH_TYPES.each do |type|
      line = type[:patterns].find { |l| check_line(l) }

      next if line.nil?

      finish_type = { pattern: line, name: type[:name] }.to_json
      break
    end

    finish_type
  end

  # check if line passed has only X or O to determine if game is over
  def check_line(pattern)
    spots = pattern.map { |spot_num| board[spot_num] }

    spots.none?(&:nil?) && spots.uniq.length == 1
  end
end
