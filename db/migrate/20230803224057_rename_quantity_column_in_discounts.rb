class RenameQuantityColumnInDiscounts < ActiveRecord::Migration[7.0]
  def change
    rename_column :discounts, :quantity, :discount_quantity
  end
end
