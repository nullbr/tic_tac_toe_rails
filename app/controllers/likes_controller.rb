# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :require_signin
  before_action :find_game

  def create
    return if existing_like

    like = @game.likes.create!(player: current_player)
    @game.my_like = like

    render partial: 'activity/game_likes',
           locals: { game: @game }
  end

  def destroy
    return unless (like = existing_like)

    like.destroy!

    render partial: 'activity/game_likes',
           locals: { game: @game }
  end

  private

  def find_game
    @game = Game.find(params[:game_id])
  end

  def existing_like
    @game.likes.where(player: current_player).first
  end
end
