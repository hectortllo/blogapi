FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { 
      r = rand(0..1)
      if r == 0
        false
      else
        true
      end
      }
    #Factory_bot es lo suficientemente 'inteligente' para hacer referencia
    #a otro factory
    user 
  end
end
