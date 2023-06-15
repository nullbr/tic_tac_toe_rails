# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :player, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
