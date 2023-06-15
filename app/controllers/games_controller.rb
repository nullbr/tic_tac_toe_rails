# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def show
    @game = Game.find(params[:id])
    @row1 = @game.board[0..2]
    @row2 = @game.board[3..5]
    @row3 = @game.board[6..9]
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(start_at: Time.zone.now, mode: game_params[:mode]&.to_i, level: game_params[:level]&.to_i)

    player1 = Player.create!(symbol: 'X', player_type: 'Human')
    player2 = Player.create!(symbol: 'O', player_type: 'Human')
    @game.players = [player1, player2]

    @game.save ? (redirect_to @game) : (render :new, status: :unprocessable_entity)
  end

  def update_board; end

  private

  def game_params
    params.require(:game).permit(:mode, :level)
  end
end
