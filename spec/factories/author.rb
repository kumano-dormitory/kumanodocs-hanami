FactoryGirl.define do
  factory :author do
    name { Faker::Name.name }
    crypt_password { Faker::Internet.password }

    initialize_with { new(attributes) }
  end
end