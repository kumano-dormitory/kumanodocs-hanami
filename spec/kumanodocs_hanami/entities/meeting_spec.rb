require 'spec_helper'

describe Meeting do
  # place your tests here
  it 'articles_for_webでソートが正しく行われていること' do
    def test_articles_for_web(test_numbers)
      shuffled_test_numbers = test_numbers.shuffle
      articles = test_numbers.map { |number|
        Article.new(number: number)
      }
      meeting = Meeting.new(articles: articles)
      articles_for_web = meeting.articles_for_web
      articles_for_web.map(&:number).must_equal test_numbers
    end

    test_articles_for_web([1, 2, 3, 4, 5])
    test_articles_for_web([2, 3, 4, 6])
    test_articles_for_web([1, 2, 3, nil])
    test_articles_for_web([1, 2, 3, nil, nil])
  end
end
