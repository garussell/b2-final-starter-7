class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.new
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new(discount_params)

    if @discount.save
      flash[:success] = "Discount was created, very generous."
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:error] = "Invalid entry, try again."
      render :new
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    Discount.find(params[:id]).destroy

    redirect_to merchant_discounts_path(merchant)
  end

  private
  def discount_params
    params.require(:discount).permit(:name, :discount_quantity, :discount_percentage)
  end
end