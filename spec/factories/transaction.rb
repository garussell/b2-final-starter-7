FactoryBot.define do
  factory :transaction, class: 'Transaction' do 
    credit_card_number { Faker::Number.number(digits: 16) }
    credit_card_expiration_date { Faker::Date.forward }
    result { Faker::Number.between(from: 0, to: 1) }
    association :invoice, factory: :invoice 
  end
end
