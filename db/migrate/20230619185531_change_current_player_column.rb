# frozen_string_literal: true

class ChangeCurrentPlayerColumn < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :current_player, :bigint
    add_column :games, :current_player_id, :integer, references: :players
  end
end
