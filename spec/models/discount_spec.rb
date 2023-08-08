require 'rails_helper'

describe Discount do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    
    # Existing Discounts
    @family_discount = @merchant1.discounts.create!(name: "Family Discount", discount_quantity: 10, discount_percentage: 0.20)
    @holiday_discount = @merchant1.discounts.create!(name: "Holiday Discount", discount_quantity: 5, discount_percentage: 0.20)
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:discount_quantity) }
    it { should validate_presence_of(:discount_percentage) }
  end

  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:items).through(:merchant) }
  end

  describe ".class_methods" do
    describe "discount_exists?" do
      it "will tell us if the discount exists" do
        expect(Discount.discount_exists?(@family_discount.name)).to be true
        expect(Discount.discount_exists?(@holiday_discount.name)).to be true
      end
    end
  end
end