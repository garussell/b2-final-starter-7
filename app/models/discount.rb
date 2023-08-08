class Discount < ApplicationRecord
  validates_presence_of :name,
                        :discount_quantity, 
                        :discount_percentage
  belongs_to :merchant
  has_many :items, through: :merchant


  def self.discount_exists?(discount)
    where("LOWER(name) LIKE ?", "%#{discount.downcase}%").exists?
  end
end