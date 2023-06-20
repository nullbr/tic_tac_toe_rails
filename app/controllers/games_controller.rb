# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :require_signin, only: %i[new create update_board]
  before_action :set_game, only: %i[show update_board]
  before_action :ensure_correct_user, only: %i[update_board]

  def index; end

  def show
    @game = Game.find(params[:id])

    board_details
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(
      start_at: Time.zone.now, mode: game_params[:mode]&.to_i, level: game_params[:level]&.to_i
    )

    if @game.save
      prepare_game
      redirect_to @game
    else
      flash.now[:alert] = @game.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def update_board
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
    params.require(:game).permit(:mode, :level, :player_2_id)
  end

  def set_game
    @game = Game.find(params[:id] || params[:game_id])
  end

  def ensure_correct_user
    return if Game.modes[@game.mode].zero? || signed_in? && current_player == @game.current_player

    flash.now[:alert] = "It's not your turn"
    render :flash
  end

  def board_details
    @rows = @game.board.each_slice(3)

    return unless (@game_over = @game.game_over?)

    @win_pattern = JSON.parse(@game.win_type)['pattern']
  end

  def prepare_game
    case Game.modes[@game.mode]
    when 0
      player2 = Player.find_or_create_by(username: 'Player 2')
      @game.game_players.create([{ player: player2, symbol: 'O' }, { player: current_player, symbol: 'X' }])

      @game.update(current_player:)
    when 1
      player2 = Player.find(game_params[:player_2_id].to_i)
      @game.game_players.create([{ player: player2, symbol: 'O' }, { player: current_player, symbol: 'X' }])

      @game.update(current_player:)
    end
  end
end
