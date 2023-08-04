FactoryBot.define do
  factory :item, class: "Item" do 
    sequence(:name) { |n| "#{Faker::Commerce.product_name} #{n}" }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.between(from: 100, to: 10000) }
    association :merchant
  end
end