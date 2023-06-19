# frozen_string_literal: true

class ChangeColumnTypeName < ActiveRecord::Migration[7.0]
  def change
    rename_column :players, :type, :player_type
  end
end
