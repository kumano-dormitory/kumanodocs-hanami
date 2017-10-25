require 'spec_helper'

describe Meeting do
  # place your tests here
  it 'sorted_articlesでソートが正しく行われていること' do
    numbers = [1, 2, 3, nil].shuffle
    articles = [
      Article.new(number: numbers[0]),
      Article.new(number: numbers[1]),
      Article.new(number: numbers[2]),
      Article.new(number: numbers[3])
    ]
    meeting = Meeting.new(articles: articles)
    sorted_articles = meeting.sorted_articles
    expected_numbers = [1, 2, 3, nil]
    sorted_articles.map(&:number).must_equal expected_numbers
  end
end
