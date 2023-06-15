# frozen_string_literal: true

class AddFieldsToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :board, :text, array: true, default: Array.new(9)
    add_column :games, :current_player, :bigint
    add_column :games, :win_type, :string
    add_column :games, :moves, :integer
  end
end
