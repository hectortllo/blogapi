FactoryBot.define do
  factory :user do
    #Se utilizará la gema 'Faker' para crear emails ficticios
    email { Faker::Internet.email }
    name { Faker::Name.name }
  end
end
