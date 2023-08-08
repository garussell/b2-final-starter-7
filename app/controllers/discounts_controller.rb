class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = HolidayFacade.get_next_three_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
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

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.discounts.find(params[:id])
    if discount.update(discount_params)
      redirect_to merchant_discount_path(merchant, discount)
    else
      redirect_to edit_merchant_discount_path(merchant, discount)
      flash[:alert] = "Invalid entry, try again."
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    Discount.find(params[:id]).destroy

    redirect_to merchant_discounts_path(merchant)
  end

  def holiday
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.new

    @selected_holiday = HolidayFacade.get_next_three_holidays.find { |holiday| holiday.name  }
  end
  
  private
  def discount_params
    params.require(:discount).permit(:name, :discount_quantity, :discount_percentage)
  end

end