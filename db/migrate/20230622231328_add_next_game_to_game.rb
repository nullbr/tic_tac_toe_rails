class AddNextGameToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :next_game_id, :integer, references: :games
  end
end
