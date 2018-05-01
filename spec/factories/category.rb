FactoryBot.define do
  factory :category do
    name { Faker::Cat.name }

    initialize_with { new(attributes) }
  end
end