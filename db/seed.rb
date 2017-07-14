#require 'faker'

meeting_rep = MeetingRepository.new
author_rep = AuthorRepository.new
article_rep = ArticleRepository.new

[2017].each do |year|
  (1..12).each do |month|
    [5, 20].each do |day|
      date = Date.new(year, month, day)
      deadline = Time.new(year, month, day, 22)
      meeting = meeting_rep.create(date: date, deadline: deadline)
    end
  end
end

meeting_rep.all.sample(10).each do |meeting|
  rand(2..5).times do
    author = author_rep.create(name: Faker::Name.name)
    article_rep.create(
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraphs.inject(&:+),
      crypt_password: Faker::Internet.password,
      author_id: author.id,
      meeting_id: meeting.id
    )
  end
end