FactoryBot.define do
  factory :invoice, class: "Invoice" do 
    status { Faker::Number.between(from: 0, to: 2) }
    association :customer, factory: :customer
  end
end

