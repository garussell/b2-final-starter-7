class RenamePercentageColumnInDiscounts < ActiveRecord::Migration[7.0]
  def change
    rename_column :discounts, :percentage, :discount_percentage
  end
end
