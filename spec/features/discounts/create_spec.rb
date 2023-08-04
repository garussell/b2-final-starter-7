require "rails_helper"

RSpec.describe "discount creation" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    visit new_merchant_discount_path(@merchant1)
  end

  describe "#create" do
    context "valid form entry" do
      it "creates new discount and flashes message 'Discount was created, very generous.'" do
        fill_in "discount[name]", with: "Black Friday"
        fill_in "discount[discount_quantity]", with: 2
        fill_in "discount[discount_percentage]", with: 0.35

        click_on "Create Discount"

        expect(page).to have_text("Discount was created, very generous.")
        expect(page).to have_current_path(merchant_discounts_path(@merchant1))
      end
    end

    context "invalid form entry" do
      it "displays a flash message 'Invalid entry, try again.' when data entry is invalid" do
        fill_in "discount[name]", with: ""
        fill_in "discount[discount_quantity]", with: ""
        fill_in "discount[discount_percentage]", with: ""

        click_on "Create Discount"

        expect(page).to have_text("Invalid entry, try again.")
        expect(page).to have_current_path(merchant_discounts_path(@merchant1))
      end
    end
  end
end