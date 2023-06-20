# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :player, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  after_create :create_player

  private

  def create_player
    Player.find_or_create_by(username:, user: self, player_type: 'Human')
  end
end
