require "rails_helper"

RSpec.describe "discounts show page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    # @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    # @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    # @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    # @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    # @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    # @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    # @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    # @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    # @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    # @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    # @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    # @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    # @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    # @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    # @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    # @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    # @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    # @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 11, unit_price: 10, status: 0)
    # @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 10, unit_price: 8, status: 0)
    # @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 12, unit_price: 5, status: 2)
    # @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    # @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    # @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    # @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    # @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    # @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    # @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    # @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    # @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    # @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    # @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

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