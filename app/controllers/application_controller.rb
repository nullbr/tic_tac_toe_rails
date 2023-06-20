# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def require_signin
    return if signed_in?

    flash.now[:alert] = 'You must be logged in first'
    session[:intended_url] = request.url
    redirect_to signin_url
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def current_player
    if session[:player_id]
      @current_player ||= Player.find(session[:player_id])
    elsif session[:user_id]
      @current_player ||= User.find(session[:user_id]).player
    end
  end

  helper_method :current_player

  def signed_in?
    !current_user.nil? || !current_player.nil?
  end

  helper_method :signed_in?

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?
end
