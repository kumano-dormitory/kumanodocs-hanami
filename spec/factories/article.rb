FactoryGirl.define do
  factory :article do
    title { Faker::Book.title }
    body  { Faker::Lorem.paragraphs.join }
    author_id { create(:author).id }
    meeting_id { create(:meeting).id }

    initialize_with { new(attributes) }

    factory :article_with_category do
      after(:create) do |article|
        create(:article_category, article_id: article.id)
      end
    end
  end
end