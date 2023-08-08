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

      # Extension: Create a Holiday Discount
      it "In the Holiday Discounts section, I see a 'create discount' button next to each of the 3 upcoming holidays" do
        within("#upcoming_holidays") do
          expect(page).to have_button("Create Labour Day Discount")
          expect(page).to have_button("Create Columbus Day Discount")
          expect(page).to have_button("Create Veterans Day Discount")
        end
      end

      it "when I click on the button I am taken to a new discount form that has the form field auto populated with the following: 'Discount: <name of holiday> Discount, Percentage Discount: 30, Quantity Threshold: 2'" do
        click_on "Create Labour Day Discount"

        expect(page).to have_current_path(holiday_merchant_discounts_path(@merchant1))
        
        within("#create_holiday_discount_form") do
          expect(page).to have_field("discount[name]", with: "Labour Day Discount")
          expect(page).to have_field("discount[discount_quantity]", with: "2")
          expect(page).to have_field("discount[discount_percentage]", with: "0.3")
        end
      end

      it "I can leave the information as is, or modify it before saving.  I should be redirected to the discounts index page where I see the newly created discount added to the list of discounts" do
        within("#bulk_discounts") do
          expect(page).to_not have_content("Columbus Day Discount")
        end

        click_on "Create Columbus Day Discount"

        fill_in "discount[name]", with: "Columbus Day Discount"
        fill_in "discount[discount_quantity]", with: 5
        fill_in "discount[discount_percentage]", with: 0.2

        click_on "Create Discount"
        
        within("#bulk_discounts") do  
          expect(page).to have_current_path(merchant_discounts_path(@merchant1))
          expect(page).to have_content("Columbus Day Discount")
        end
      end

      # Extension: View a Holiday Discount
      it "If i have created a holiday discount for a specific holiday, within the upcoming holidays section I should not see the button to create a discount next to that holiday" do
        expect(page).to have_button("Create Labour Day Discount")
        
        click_on "Create Labour Day Discount"
        fill_in "discount[name]", with: "Labour Day"
        click_on "Create Discount"
  
        within("#upcoming_holidays") do
          expect(page).to_not have_button("Create Labour Day Discount") 
        end
      end

      it "instead I should see a 'view discount' link, when I click the link I am taken to the discount show page for that holiday discount" do
        click_on "Create Labour Day Discount"
        fill_in "discount[name]", with: "Labour Day"

        click_on "Create Discount"
  
        within("#upcoming_holidays") do
          expect(page).to have_link("View Discount") 
          click_on "View Discount"
        end

        expect(page).to have_current_path(merchant_discount_path(@merchant1, Discount.find_id("Labour Day")))
      end

      describe '.select_holiday' do
        before(:each) do
          @holiday1 = Holiday.new(name: 'First Holiday', date: "2023-10-30")
          @holiday2 = Holiday.new(name: 'Next Holiday', date: "2023-11-07")
          @holiday3 = Holiday.new(name: 'Last Holiday', date: "2023-12-25")
          
        end
        
        it 'returns the holiday with the specified name' do
          allow(HolidayFacade).to receive(:select_holiday).with('First Holiday').and_return(@holiday1)
          allow(HolidayFacade).to receive(:select_holiday).with('Next Holiday').and_return(@holiday2)
          allow(HolidayFacade).to receive(:select_holiday).with('Last Holiday').and_return(@holiday3)

          selected_holiday = HolidayFacade.select_holiday('Next Holiday')
          expect(selected_holiday).to eq(@holiday2)
        end
    
        it 'returns nil if no holiday with the specified name is found' do
          selected_holiday = HolidayFacade.select_holiday('Nonexistent Holiday')
          expect(selected_holiday).to be_nil
        end
      end
    end
  end
end