require "rails_helper"

describe "Admin Invoices Show Page" do
  before :each do
    @merchant1 = Merchant.create!(name: "Merchant 1")
    @discount = @merchant1.discounts.create!(name: "Because I'm nice", discount_quantity: 10, discount_percentage: 0.20)

    @customer1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @customer2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @invoice1 = Invoice.create!(customer_id: @customer1.id, status: 2, created_at: "2012-03-25 09:54:09")
    @invoice2 = Invoice.create!(customer_id: @customer2.id, status: 1, created_at: "2012-03-25 09:30:09")

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)

    visit admin_invoice_path(@invoice1)
  end

  describe "as an admin" do
    describe "when I visit an admin invoice show page" do  
      it "should display the id, status and created_at" do
        expect(page).to have_content("Invoice ##{@invoice1.id}")
        expect(page).to have_content("Created on: #{@invoice1.created_at.strftime("%A, %B %d, %Y")}")

        expect(page).to_not have_content("Invoice ##{@invoice2.id}")
      end

      it "should display the customers name and shipping address" do
        expect(page).to have_content("#{@customer1.first_name} #{@customer1.last_name}")
        expect(page).to have_content(@customer1.address)
        expect(page).to have_content("#{@customer1.city}, #{@customer1.state} #{@customer1.zip}")

        expect(page).to_not have_content("#{@customer2.first_name} #{@customer2.last_name}")
      end

      it "should display all the items on the invoice" do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_2.name)

        expect(page).to have_content(@ii_1.quantity)
        expect(page).to have_content(@ii_2.quantity)

        expect(page).to have_content("$#{@ii_1.unit_price}")
        expect(page).to have_content("$#{@ii_2.unit_price}")

        expect(page).to have_content(@ii_1.status)
        expect(page).to have_content(@ii_2.status)

        expect(page).to_not have_content(@ii_3.quantity)
        expect(page).to_not have_content("$#{@ii_3.unit_price}")
        expect(page).to_not have_content(@ii_3.status)
      end

      it "should display the total revenue the invoice will generate" do
        expect(page).to have_content("Total Revenue: $#{@invoice1.total_revenue}")

        expect(page).to_not have_content(@invoice2.total_revenue)
      end

      it "should have status as a select field that updates the invoices status" do
        within("#status-update-#{@invoice1.id}") do
          select("cancelled", :from => "invoice[status]")
          expect(page).to have_button("Update Invoice")
          click_button "Update Invoice"

          expect(current_path).to eq(admin_invoice_path(@invoice1))
          expect(@invoice1.status).to eq("completed")
        end
      end

      # User Story 8
      it "then I see the total revenue from this invoice (not including discounts)" do
        expect(page).to have_content(@invoice1.total_revenue)
      end

      it "and I see the total discounted revenue from this invoice which includes bulk discounts in the calculation" do
        expect(page).to have_content(@invoice1.revenue_after_discount)
      end
    end
  end
end
