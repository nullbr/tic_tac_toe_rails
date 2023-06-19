class SetGameMovesDefaultValue < ActiveRecord::Migration[7.0]
  def change
    change_column :games, :moves, :integer, default: 0
  end
end
