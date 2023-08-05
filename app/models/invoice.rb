class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def eligible_for_discount
    eligible_items = invoice_items.select do |invoice_item|
      discount = invoice_item.item.discounts.where('discount_quantity <= ?', invoice_item.quantity).order(discount_quantity: :desc).first
      discount.present?
    end

    eligible_items
  end

  def discount_amount
    percentage = discounts.pluck(:discount_percentage).first
    total_discount = 0

    eligible_for_discount.each do |invoice_item|
      total_discount += invoice_item.quantity * invoice_item.unit_price * percentage
    end
 
    total_discount 
  end

  def revenue_after_discount
    total_revenue - discount_amount
  end


end
