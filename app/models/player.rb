# frozen_string_literal: true

class Player < ApplicationRecord
  enum :player_type, %w[Human Computer]

  belongs_to :user, optional: true

  has_many :likes, dependent: :destroy
  has_many :game_players, dependent: :destroy
  has_many :games, through: :game_players, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def assign_my_likes_to_games(game_list)
    my_likes = likes.where(game: game_list)
    game_list.map do |game|
      game.my_like =
        my_likes.find { |l| l.game_id == game.id }
      game
    end
  end
end
