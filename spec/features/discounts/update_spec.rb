require 'rails_helper'

RSpec.describe "discount update" do
  before(:each) do
    @merchant1 = Merchant.create!(name: "Hair Care")
    @discount = @merchant1.discounts.create!(name: "Family Discount", discount_quantity: 10, discount_percentage: 0.20)
 
    visit edit_merchant_discount_path(@merchant1, @discount)
  end

  describe "#update" do
    context "invalid form entry" do
      it "updates discount and flashes message 'Invalid entry, try again.' when data entry is invalid" do
        fill_in "discount[name]", with: ""
        fill_in "discount[discount_quantity]", with: 2
        fill_in "discount[discount_percentage]", with: 0.35

        click_on "Update Discount"

        expect(page).to have_text("Invalid entry, try again.")
        expect(page).to have_current_path(edit_merchant_discount_path(@merchant1, @discount))
      end
    end
  end
end