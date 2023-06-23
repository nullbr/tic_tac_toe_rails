class AddLikesCountToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :likes_count, :integer, default: 0
  end
end
