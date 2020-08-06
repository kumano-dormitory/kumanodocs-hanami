require 'spec_helper'

describe Meeting do
  def assert_articles_for_web(test_numbers)
    shuffled_test_numbers = test_numbers.shuffle
    articles = test_numbers.map { |number|
      Article.new(number: number)
    }
    meeting = Meeting.new(articles: articles)
    articles_for_web = meeting.articles_for_web
    _(articles_for_web.map(&:number)).must_equal test_numbers
  end

  it 'articles_for_webでソートが正しく行われていること' do
    assert_articles_for_web([1, 2, 3, 4, 5])
    assert_articles_for_web([2, 3, 4, 6])
    assert_articles_for_web([1, 2, 3, nil])
    assert_articles_for_web([1, 2, 3, nil, nil])
  end
end
