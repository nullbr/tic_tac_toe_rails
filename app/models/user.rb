# frozen_string_literal: true

class User < ApplicationRecord
  has_many :games, through: :user_games, dependent: :destroy
end
