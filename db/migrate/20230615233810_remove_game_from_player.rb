class RemoveGameFromPlayer < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :game_id
  end
end
