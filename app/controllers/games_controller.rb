# frozen_string_literal: true

class GamesController < ApplicationController
  def index; end

  def show
    @game = Game.find(params[:id])
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(start_at: Time.zone.now, mode: game_params[:mode]&.to_i, level: game_params[:level]&.to_i)
    @game.users = [current_user] if signed_in?

    render :new, status: :unprocessable_entity unless @game.save

    redirect_to @game
  end

  private

  def game_params
    params.require(:game).permit(:mode, :level)
  end
end
