class AddSymbolToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :symbol, :string, null: false
  end
end
