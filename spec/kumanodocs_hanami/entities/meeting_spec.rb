require 'spec_helper'

describe Meeting do
  # place your tests here
  it 'sorted_articlesでソートが正しく行われていること' do
    numbers = [1, 2, 3].shuffle
    articles = [
      create(:article, number: numbers[0]),
      create(:article, number: numbers[1]),
      create(:article, number: numbers[2]),
      create(:article, number: nil)
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
