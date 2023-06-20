# frozen_string_literal: true

class Player < ApplicationRecord
  enum :player_type, %w[Human Computer]

  belongs_to :user, optional: true

  has_many :game_players, dependent: :destroy
  has_many :games, through: :game_players, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
