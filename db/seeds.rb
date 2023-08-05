InvoiceItem.destroy_all
Item.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Customer.destroy_all
Merchant.destroy_all

Rake::Task["csv_load:all"].invoke

# Create merchants
@merchant1 = Merchant.create!(name: "Barbie Maker")
@merchant2 = Merchant.create!(name: "High Quality Junk")

# Create discounts and associate them with merchants
@discount1 = @merchant1.discounts.create!(name: "Family Discount", discount_quantity: 10, discount_percentage: 0.2)
@discount2 = @merchant2.discounts.create!(name: "Premium Discount", discount_quantity: 5, discount_percentage: 0.1)
