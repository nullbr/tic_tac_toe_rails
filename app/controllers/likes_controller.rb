# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :find_game

  def create
    return if !current_player || existing_like

    like = @game.likes.create!(player: current_player)
    @game.my_like = like
  end

  def destroy
    return unless current_player && (like = existing_like)

    like.destroy!
  end

  private

  def find_game
    @game = Game.find(params[:game_id])
  end

  def existing_like
    @game.likes.where(player: current_player).first
  end
end
