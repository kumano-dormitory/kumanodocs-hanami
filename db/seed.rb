# require 'faker'
require 'bcrypt'

meeting_rep = MeetingRepository.new
author_rep = AuthorRepository.new
article_rep = ArticleRepository.new
category_rep = CategoryRepository.new
block_repo = BlockRepository.new
table_repo = TableRepository.new
user_repo = UserRepository.new

[2018, 2019].each do |year|
  (1..12).each do |month|
    [5, 20].each do |day|
      date = Date.new(year, month, day)
      deadline = Time.new(year, month, day, 22)
      meeting_rep.create(date: date, deadline: deadline)
    end
  end
end

meeting_rep.all.each do |meeting|
  rand(5..15).times do
    author = author_rep.create(name: Faker::Name.name, crypt_password: Faker::Internet.password)
    article = article_rep.create(
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraphs.inject(&:+),
      author_id: author.id,
      meeting_id: meeting.id
    )
    rand(0..1).times do
      table_repo.create(
        caption: Faker::Lorem.sentence,
        csv: "項目\t予算\t支出\n#{Faker::Lorem.word}\t20000\t17850\n#{Faker::Lorem.word}\t3000\t2700\n#{Faker::Lorem.word}\t2000\t1800\n計\t25000\t22350",
        article_id: article.id
      )
    end
  end
end

[
  { name: '周知', require_content: false },
  { name: '議論', require_content: false },
  { name: '採決', require_content: true  },
  { name: '採決予定', require_content: false }
].each { |props| category_rep.create(props) }

categories = category_rep.all
article_rep.all.each do |article|
  cates = categories.sample(rand(1..2))
  datas = cates.map { |c| { category_id: c.id , extra_content: Faker::Lorem.sentence } }
  article_rep.add_categories(article, datas)
end

[
  { name: 'A1' },
  { name: 'A2' },
  { name: 'A3' },
  { name: 'A4' },
  { name: 'B12' },
  { name: 'B3' },
  { name: 'B4' },
  { name: 'C12' },
  { name: 'C34' }
].each { |prop| block_repo.create(prop) }

user_repo.create(name: 'admin', crypt_password: BCrypt::Password.create('pass'))
