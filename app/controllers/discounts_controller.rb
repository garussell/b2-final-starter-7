class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    # @discounts = @merchant.discounts.bulk_discounts(20, 10)
  end
end