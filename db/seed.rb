# require 'faker'

meeting_rep = MeetingRepository.new
author_rep = AuthorRepository.new
article_rep = ArticleRepository.new
category_rep = CategoryRepository.new

[2017].each do |year|
  (1..12).each do |month|
    [5, 20].each do |day|
      date = Date.new(year, month, day)
      deadline = Time.new(year, month, day, 22)
      meeting_rep.create(date: date, deadline: deadline)
    end
  end
end

meeting_rep.all.sample(10).each do |meeting|
  rand(2..5).times do
    author = author_rep.create(name: Faker::Name.name, crypt_password: Faker::Internet.password)
    article_rep.create(
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraphs.inject(&:+),
      author_id: author.id,
      meeting_id: meeting.id
    )
  end
end

[
  { name: '周知', require_content: false },
  { name: '議論', require_content: false },
  { name: '採決', require_content: true  }
].each { |props| category_rep.create(props) }
