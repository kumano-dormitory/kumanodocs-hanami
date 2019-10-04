FactoryBot.define do
  factory :category do
    name { Faker::Creature::Cat.name }

    initialize_with { new(attributes) }
  end
end
