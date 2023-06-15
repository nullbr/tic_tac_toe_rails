# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session[:intended_url] || user
      session[:intended_url]
    else
      flash.now[:alert] = 'Username or email was wrong'
      render :new, status: :unprocessable_entity
    end
  end

  def signout
    session[:user_id] = nil
    redirect_to root_url
  end
end
