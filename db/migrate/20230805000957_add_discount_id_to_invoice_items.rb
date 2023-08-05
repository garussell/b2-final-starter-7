class AddDiscountIdToInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :invoice_items, :discount, null: false, foreign_key: true, null: true
  end
end
