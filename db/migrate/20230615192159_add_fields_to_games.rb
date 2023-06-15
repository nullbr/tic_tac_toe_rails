# frozen_string_literal: true

class AddFieldsToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :start_at, :datetime
    add_column :games, :end_at, :datetime
  end
end
