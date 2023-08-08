module ApplicationHelper
  def holiday_discount_urls(merchant, holiday)
    discount = Discount.find_id(holiday.name)
    
    if discount && Discount.discount_exists?(holiday.name)
      link_to "View Discount", merchant_discount_path(merchant, discount), data: { turbo: false }
    else
      button_to "Create #{holiday.name} Discount", new_merchant_discount_path(merchant), method: :get, data: { turbo: false }
    end
  end
end
