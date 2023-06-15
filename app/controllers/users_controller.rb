# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update destroy]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    authenticated =  @user.authenticate(user_params[:current_password])
    if authenticated && @user.update(user_params.except(:current_password))
      redirect_to @user, notice: 'Account successfully updated!'
    else
      @user.errors.full_messages.each { |m| flash.now[:alert] = m }

      flash.now[:alert] = 'Wrong current password' unless authenticated

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    redirect_to root_url, alert: 'Account successfully deleted!'
  end

  def user_params
    params.require(:user).permit(:username, :current_password, :password, :password_confirmation)
  end

  def require_correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user?(@user)
  end
end
