require 'spec_helper'

describe Meeting do
  # place your tests here
  it 'sorted_articlesでソートが正しく行われていること' do
    numbers = [1, 2, 3].shuffle
    articles = [
      Article.new(number: numbers[0]),
      Article.new(number: numbers[1]),
      Article.new(number: numbers[2]),
      Article.new(number: numbers[3])
    ]
    meeting = Meeting.new(articles: articles)
    sorted_articles = meeting.sorted_articles
    sorted_articles.each_with_index do |article, index|
      if article.number != nil
        article.number.must_equal index + 1
      end
    end
  end
end
