# frozen_string_literal: true

module GamesHelper
  def win_pattern(game)
    return unless game.win_type

    JSON.parse(game.win_type)['pattern']
  end

  def board_rows(game)
    game.board.each_slice(3)
  end

  def class_for_spot(spot, game)
    "p-10 hover:shadow-inner #{'bg-green-200' if game.game_over? && win_pattern(game).include?(spot)}"
  end
end
