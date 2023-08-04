class Discount < ApplicationRecord
  validates_presence_of :discount_quantity, 
                        :discount_percentage
  belongs_to :merchant
  has_many :items, through: :merchant
end