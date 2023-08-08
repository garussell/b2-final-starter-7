require "rails_helper"

RSpec.describe "discounts show page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    # Existing Discounts
    @family_discount = @merchant1.discounts.create!(name: "Family Discount", discount_quantity: 10, discount_percentage: 0.20)
    @holiday_discount = @merchant1.discounts.create!(name: "Holiday Discount", discount_quantity: 5, discount_percentage: 0.20)
  end
  
  # User Story 4
  describe "as a merchant" do
    describe "when I visit my bulk discount show page" do
      it "I see the bulk discount's quantity threshold and percentage discount" do
        visit merchant_discount_path(@merchant1, @family_discount)

        within("#discount_attributes") do
          expect(page).to have_content(@family_discount.name)
          expect(page).to have_content(@family_discount.discount_quantity)
          expect(page).to have_content("#{(@family_discount.discount_percentage * 100).to_i}%")
        end
      end

      # User Story 5
      it "I see a link to edit the bulk discount" do
        visit merchant_discount_path(@merchant1, @family_discount)
        
        within("#link_to_edit_discount") do
          expect(page).to have_link("Edit #{@family_discount.name}")
        end
      end

      it "when I click this link, I am taken to a new page with a form to edit the discount and I see that the discounts current attributes are pre-populated in the form" do
        visit merchant_discount_path(@merchant1, @holiday_discount)

        click_on "Edit #{@holiday_discount.name}"
        expect(page).to have_current_path(edit_merchant_discount_path(@merchant1, @holiday_discount))

        # pre-populated form
        within("#edit_discount_form") do
          expect(page).to have_field("discount[name]", with: @holiday_discount.name)
          expect(page).to have_field("discount[discount_quantity]", with: @holiday_discount.discount_quantity)
          expect(page).to have_field("discount[discount_percentage]", with: @holiday_discount.discount_percentage)
        end
      end

      it "when I change any/all of the information and click submit, I am redirected to the bulk discount's show page and see that the discount's attributes have been updated" do
        visit edit_merchant_discount_path(@merchant1, @holiday_discount)
        expect(page).to_not have_content("Code Smell Discount")

        fill_in "discount[name]", with: "Code Smell Discount"
        fill_in "discount[discount_quantity]", with: 5
        fill_in "discount[discount_percentage]", with: 0.3
      
        click_on "Update Discount"

        expect(page).to have_current_path(merchant_discount_path(@merchant1, @holiday_discount))
        expect(page).to have_content("Code Smell Discount")
        expect(page).to have_content(5)
        expect(page).to have_content("30%")
      end
    end
  end
end