# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def show
    @game = Game.find(params[:id])

    board_details
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

    return unless @game.input_to_board(params[:spot])

    board_details

    render partial: 'games/game',
           locals: {
             game: @game,
             win_pattern: @win_pattern
           }
  end

  private

  def game_params
    params.require(:game).permit(:mode, :level)
  end

  def board_details
    @rows = @game.board.each_slice(3)

    return unless (@game_over = @game.game_over?)

    @win_pattern = JSON.parse(@game.win_type)['pattern']
  end
end
