# frozen_string_literal: true

class ActivityController < ApplicationController
  def index
    @pagy, @games = pagy(Game.order(created_at: :desc).includes(:players), items: 5)

    @games = current_player.assign_my_likes_to_games(@games) if current_player
  end
end
