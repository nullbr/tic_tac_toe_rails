# frozen_string_literal: true

class AddSymbolToGamePlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :game_players, :symbol, :string, null: false, default: 'X'
  end
end
