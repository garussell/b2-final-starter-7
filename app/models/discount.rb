class Discount < ApplicationRecord
  validates_presence_of :name,
                        :discount_quantity, 
                        :discount_percentage
  belongs_to :merchant
  has_many :items, through: :merchant


  def self.discount_exists?(discount)
    where("LOWER(name) LIKE ?", "%#{discount.downcase}%").exists?
  end

  # def self.discount_exists?(discount)
  #   fuzzy_matcher = FuzzyMatch.new(Discount.all, read: :name)
  #   fuzzy_matcher.find_with_score(discount).last >= 0.5
  # end

  def self.find_id(name)
    where(name: name).pluck(:id).first
  end
end