# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :mode
      t.integer :level

      t.timestamps
    end
  end
end
