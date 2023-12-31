# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :set_game, only: %i[show update_board play_again]
  before_action :ensure_correct_user, only: %i[update_board]

  def index
    @pagy, @games = pagy(Game.order(created_at: :desc).includes(:players), items: params[:per_page] ||= 5,
                                                                           link_extra: 'data-turbo-action="advance"')

    @games = current_player.assign_my_likes_to_games(@games) if current_player
  end

  def show
    @game = Game.find(params[:id])
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
    if @game.input_to_board(params[:spot])
      render partial: 'games/game',
             locals: {
               game: @game,
               win_pattern: @win_pattern
             }
    else
      flash.now[:alert] = 'Invalid spot'
      render :flash
    end
  end

  def play_again
    new_game = Game.new(
      start_at: Time.zone.now, mode: @game.mode, level: @game.level,
      players: @game.players, current_player: @game.current_player
    )

    if new_game.save
      @game.update(next_game_id: new_game.id)
      new_game.update(invitation_token: nil)

      redirect_to game_path(new_game)
    else
      flash.now[:alert] = new_game.errors.full_messages.first
      render :show
    end
  end

  def invite
    @game = Game.find_by(invitation_token: params[:invitation_token])

    if @game && @game.game_players.find_by(player: current_player).nil?
      @game.game_players.create(player: current_player, symbol: 'O')
      @game.update(invitation_token: nil)
      redirect_to game_path(@game), notice: "Let's play!"
    elsif @game
      redirect_to game_path(@game), notice: 'You are already in this game'
    else
      redirect_to root_url, alert: 'Invalid invitation link'
    end
  end

  private

  def game_params
    params.require(:game).permit(:mode, :level)
  end

  def set_game
    @game = Game.find_by(id: params[:id] || params[:game_id])

    return if @game

    redirect_to root_url, alert: 'The game you are looking for does not exist'
  end

  def ensure_correct_user
    return if Game.modes[@game.mode].zero? || signed_in? && current_player == @game.current_player

    flash.now[:alert] = "It's not your turn"
    render :flash
  end

  def prepare_game
    case Game.modes[@game.mode]
    when 0
      player2 = Player.find_or_create_by(username: 'Player 2')
      @game.game_players.create([{ player: player2, symbol: 'O' }, { player: current_player, symbol: 'X' }])

      @game.update(current_player:)
    when 1
      @game.game_players.create(player: current_player, symbol: 'X')

      @game.update(current_player:)
    end
  end
end
