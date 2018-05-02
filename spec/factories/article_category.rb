FactoryBot.define do
  factory :article_category do
    article_id { create(:article).id }
    category_id { create(:category).id }
    extra_content { Faker::Lorem.paragraph }

    initialize_with { new(attributes) }
  end
end