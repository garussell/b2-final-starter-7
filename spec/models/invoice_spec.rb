require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:each) do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    
    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
    @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
    
    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
    
    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_8.id, quantity: 10, unit_price: 8, status: 2)
    @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
    
    @discount = @merchant1.discounts.create!(name: "Because I'm nice", discount_quantity: 10, discount_percentage: 0.20)
  end

  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end

  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:transactions) }
    it { should have_many(:discounts).through(:merchants) }
  end

  describe "instance methods" do
    it "total_revenue" do
      expect(@invoice_1.total_revenue).to eq(100)
      expect(@invoice_2.total_revenue).to eq(180)
    end

    it "eligible_for_discount" do
      expect(@invoice_1.eligible_for_discount).to eq([])
      expect(@invoice_2.eligible_for_discount).to eq([@ii_2, @ii_3])
    end

    it "discount_amount" do
      expect(@invoice_1.discount_amount).to eq(0)
      expect(@invoice_2.discount_amount).to eq(36.0)
    end

    it "revenue_after_discount" do
      expect(@invoice_1.revenue_after_discount).to eq(100.0)
      expect(@invoice_2.revenue_after_discount).to eq(144.0)
    end

    xit "apply_discount(discount)" do
      eligible_item = @invoice_2.eligible_for_discount.first
      
    
    end
  end
end
