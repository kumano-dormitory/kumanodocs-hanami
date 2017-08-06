require 'spec_helper'

describe ArticleRepository do
  let(:meeting_repo) { MeetingRepository.new }
  let(:category_repo) { CategoryRepository.new }
  let(:article_repo) { ArticleRepository.new }
  let(:author_repo) { AuthorRepository.new }
  let(:ac_repo) { ArticleCategoryRepository.new }

  before do
    meeting_date = Date.today + 30
    meeting = meeting_repo.create(date: meeting_date, deadline: (meeting_date - 2).to_time)
    category_repo.create(5.times.map { { name: Faker::Cat.name } })
    author_repo.create(5.times.map { { name: Faker::Name.name, crypt_password: Faker::Internet.password } })

    article_params = author_repo.all.map do |author|
      {
        title: Faker::Book.title,
        body: Faker::Lorem.paragraphs.join,
        author_id: author.id,
        meeting_id: meeting.id
      }
    end
    article_repo.create(article_params)
  end

  it 'categoryを追加/更新できること' do
    article = article_repo.all.sample
    categories = category_repo.all.sample(2)
    
    # 追加
    article_repo.add_categories(
      article,
      categories.map { |category| { category_id: category.id } }
    )
    ac_repo.all.count.must_equal categories.count

    # 更新
    categories = category_repo.all.sample(3)
    article_repo.update_categories(
      article,
      categories.map { |category| { category_id: category.id } }
    )
    ac_repo.all.count.must_equal categories.count
  end
end
