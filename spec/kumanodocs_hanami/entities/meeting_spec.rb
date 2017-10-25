require 'spec_helper'

describe Meeting do
  # place your tests here
  it 'articles_for_webでソートが正しく行われていること' do
    numbers = [1, 2, 3, nil].shuffle
    articles = [
      Article.new(number: numbers[0]),
      Article.new(number: numbers[1]),
      Article.new(number: numbers[2]),
      Article.new(number: numbers[3])
    ]
    meeting = Meeting.new(articles: articles)
    articles_for_web = meeting.articles_for_web
    expected_numbers = [1, 2, 3, nil]
    articles_for_web.map(&:number).must_equal expected_numbers
  end
end
