# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def show
    @game = Game.find(params[:id])
    @rows = @game.board.each_slice(3)

    return unless (@game_over = @game.game_over?)

    @win_pattern = JSON.parse(@game.win_type)['pattern']
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(start_at: Time.zone.now, mode: game_params[:mode]&.to_i, level: game_params[:level]&.to_i)

    player1 = Player.create!(symbol: 'X', player_type: 'Human')
    player2 = Player.create!(symbol: 'O', player_type: 'Human')
    @game.players = [player1, player2]
    @game.current_player = player1

    @game.save ? (redirect_to @game) : (render :new, status: :unprocessable_entity)
  end

  def update_board
    @game = Game.find(params[:game_id])
    @game.input_to_board(params[:spot])

    redirect_to @game
  end

  private

  def game_params
    params.require(:game).permit(:mode, :level)
  end
end
