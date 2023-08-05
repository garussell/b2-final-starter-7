class SetDefaultDiscountIdForExistingInvoiceItems < ActiveRecord::Migration[7.0]
  def up
    default_discount_id = Discount.find_by(name: "Family Discount")&.id
    change_column :invoice_items, :discount_id, :bigint, default: default_discount_id
  end

  def down
    change_column :invoice_items, :discount_id, :bigint, default: nil
  end
end
