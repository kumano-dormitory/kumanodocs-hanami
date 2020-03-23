# require 'faker'
require 'bcrypt'

meeting_rep = MeetingRepository.new
author_rep = AuthorRepository.new
article_rep = ArticleRepository.new
category_rep = CategoryRepository.new
block_repo = BlockRepository.new
table_repo = TableRepository.new
comment_repo = CommentRepository.new
vote_result_repo = VoteResultRepository.new
user_repo = UserRepository.new
document_repo = DocumentRepository.new

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

[2018].each do |year|
  (7..12).each do |month|
    [5, 20].each do |day|
      date = Date.new(year, month, day)
      deadline = Time.new(year, month, day - 2, 22)
      meeting_rep.create(date: date, deadline: deadline)
    end
  end
end

(1..12).each do |month|
  [5, 20].each do |day|
    date = Date.new(2019, month, day)
    deadline = Time.new(2019, month, day - 2, 20)
    meeting_rep.create(date: date, deadline: deadline)
  end
end

blocks = block_repo.all

meeting_rep.all.each do |meeting|
  rand(5..15).times do
    author = author_rep.create(name: Faker::Name.name, crypt_password: Faker::Internet.password)
    article = article_rep.create(
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraphs.inject(&:+) + "\n" + Faker::Lorem.paragraphs(12).inject(&:+) + "\n" + Faker::Lorem.paragraphs(8).inject(&:+),
      checked: true,
      printed: true,
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
    blocks.each do |block|
      if rand(0..3) == 0
        comment_repo.create(
          body: Faker::Lorem.paragraphs.inject(&:+),
          crypt_password: Faker::Internet.password,
          article_id: article.id,
          block_id: block.id
        )
      end
    end
  end
  articles = article_rep.by_meeting(meeting.id).to_a
  numbers = (1..(articles.length)).to_a.shuffle
  articles.each_with_index do |article, index|
    article_rep.update(article.id, number: numbers[index])
  end
end

[
  { name: '周知', require_content: false },
  { name: '議論', require_content: false },
  { name: '採決', require_content: true  },
  { name: '募集', require_content: false },
  { name: '採決予定', require_content: true }
].each { |props| category_rep.create(props) }

categories = category_rep.all
article_rep.all.each do |article|
  cates = categories.sample(rand(1..2))
  datas = cates.map { |c| { category_id: c.id , extra_content: Faker::Lorem.sentence } }
  article_rep.add_categories(article, datas)
  if cates.find{ |category| category.name == '採決' }
    blocks.each do |block|
      params = {
        agree: rand(0..20),
        disagree: rand(0..20),
        onhold: rand(0..6),
        crypt_password: Faker::Internet.password,
        article_id: article.id,
        block_id: block.id
      }
      vote_result_repo.create(params)
    end
  end
end

[
  { name: '文化部', crypt_password: BCrypt::Password.create('pass'), authority: 1 },
  { name: '炊事部', crypt_password: BCrypt::Password.create('pass'), authority: 1 },
  { name: '人権擁護部', crypt_password: BCrypt::Password.create('pass'), authority: 1 },
  { name: '庶務部', crypt_password: BCrypt::Password.create('pass'), authority: 1 },
  { name: '厚生部', crypt_password: BCrypt::Password.create('pass'), authority: 1 },
  { name: '情報部', crypt_password: BCrypt::Password.create('pass'), authority: 1 }
].each { |props| user_repo.create(props) }
users = user_repo.all
num = 0
rand(3..6).times do
  user = users.sample
  params = {
    title: Faker::Lorem.sentence,
    type: 0, # rand(0..3)
    body: Faker::Lorem.paragraphs.inject(&:+),
    number: num,
    user_id: user.id
  }
  document_repo.create(params)
  num = num + 1
end

user_repo.create(name: 'super', crypt_password: BCrypt::Password.create('pass'), authority: 3)
user_repo.create(name: 'admin', crypt_password: BCrypt::Password.create('pass'), authority: 2)
user_repo.create(name: 'kumano', crypt_password: BCrypt::Password.create('pass'), authority: 0)
