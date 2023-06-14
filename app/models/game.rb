# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :users, through: :user_games, dependent: :destroy
end
