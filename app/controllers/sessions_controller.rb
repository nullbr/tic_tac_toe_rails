# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      flash.now[:notice] = 'Logged in successfully'

      redirect_to session[:intended_url] || user
      session[:intended_url] = nil
    else
      flash.now[:alert] = 'Username or email was wrong'
      render :new, status: :unprocessable_entity
    end
  end

  def create_guest
    player = Player.new(username: generate_random_username)

    if player.save
      session[:player_id] = player.id

      flash.now[:notice] = 'Guest created successfully'

      redirect_to session[:intended_url] || root_path
      session[:intended_url]
    else
      flash.now[:alert] = 'Username invalid'
      render :new, status: :unprocessable_entity
    end
  end

  def signout
    session[:user_id] = nil
    session[:player_id] = nil
    redirect_to root_url
  end

  private

  def generate_random_username
    adjectives = %w[Happy Sleepy Grumpy Dopey Bashful Sneezy Doc]
    nouns = %w[Dwarf Dwarfie User Guest Player Stranger]

    adjective = adjectives.sample
    noun = nouns.sample
    random_number = rand(100..999)

    "#{adjective}#{noun}#{random_number}"
  end
end
