# frozen_string_literal: true

class RemoveSymbolFromPlayer < ActiveRecord::Migration[7.0]
  def change
    remove_column :players, :symbol
  end
end
