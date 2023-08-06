require "rails_helper"

RSpec.describe "discounts index page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Hair Care")

    @customer_1 = Customer.create!(first_name: "Joey", last_name: "Smith")
    @customer_2 = Customer.create!(first_name: "Cecilia", last_name: "Jones")
    @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Carrey")
    @customer_4 = Customer.create!(first_name: "Leigh Ann", last_name: "Bron")
    @customer_5 = Customer.create!(first_name: "Sylvester", last_name: "Nader")
    @customer_6 = Customer.create!(first_name: "Herber", last_name: "Kuhn")

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 11, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 10, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 12, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    # Existing Discounts
    @family_discount = @merchant1.discounts.create!(name: "Family Discount", discount_quantity: 10, discount_percentage: 0.20)
    @holiday_discount = @merchant1.discounts.create!(name: "Holiday Discount", discount_quantity: 5, discount_percentage: 0.20)
    
    visit merchant_discounts_path(@merchant1)
  end
  
  # User Story 2
  describe "as a merchant" do
    describe "when I visit my bulk discounts index page" do
      it "then I see a link to create a new discount" do
        expect(page).to have_link("Create New Discount")
      end

      it "when I click this link I am taken to a new page where I see a form to add a new bulk discount" do
        click_link "Create New Discount"
        expect(page).to have_current_path(new_merchant_discount_path(@merchant1))
      
        expect(page).to have_field("discount[name]")
        expect(page).to have_field("discount[discount_quantity]")
        expect(page).to have_field("discount[discount_percentage]")  
      end

      it "when I fill in the form with valid data, I am redirected back to the bulk discount index and see my new bulk discount listed" do
        expect(page).to_not have_content("Black Friday")
        
        visit new_merchant_discount_path(@merchant1)

        fill_in "discount[name]", with: "Black Friday"
        fill_in "discount[discount_quantity]", with: 2
        fill_in "discount[discount_percentage]", with: 0.35

        click_on "Create Discount"
        expect(page).to have_current_path(merchant_discounts_path(@merchant1))
        expect(page).to have_content("Black Friday")
        expect(page).to have_content(2)
        expect(page).to have_content("35%")
      end

      # User Story 3
      it "next to each bulk discount I see a link to delete it" do
        expect(page).to have_content("Delete #{@family_discount.name}")
        expect(page).to have_content("Delete #{@holiday_discount.name}")
      end

      it "when I click this link, I am rerdirected back to the bulk discounts index page and no longer see the discount listed" do
        expect(page).to have_content(@family_discount.name)

        click_on "Delete #{@family_discount.name}"
        expect(page).to have_current_path(merchant_discounts_path(@merchant1))
        expect(page).to_not have_content(@family_discount.name)
      end

      # User Story 9
      it "I see a section with a header of 'Upcoming Holidays'" do
        expect(page).to have_content("Upcoming Holidays")
      end

      it "In this section the name and date of the next 3 upcoming US holidays are listed" do
        # this will fail after Labour Day
        within("#upcoming_holidays") do
          expect(page).to have_content("Name: Labour Day")
          expect(page).to have_content("Date: 2023-09-04")
          expect(page).to have_content("Name: Columbus Day")
          expect(page).to have_content("Date: 2023-10-09")
          expect(page).to have_content("Name: Veterans Day")
          expect(page).to have_content("Date: 2023-11-10")
        end
      end
    end
  end
end