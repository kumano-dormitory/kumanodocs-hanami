require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_number/update'

describe Admin::Controllers::ArticleNumber::Update do
  let(:action) { Admin::Controllers::ArticleNumber::Update.new }
  let(:article_repo) { ArticleRepository.new }
  let(:articles) { create_list(:article, 5) }
  let(:meeting) { create(:meeting) }

  it 'is successful' do
    numbers = ["1", "2", "3"].shuffle
    articles.each { |article|
      article_repo.update(article.id, meeting_id: meeting.id)
    }
    article_params = articles.sample(3).map.with_index { |article, index| {'article_id' => "#{article.id}", 'number' => numbers[index]} }
    params = {id: meeting.id, meeting: {articles: article_params} }

    response = action.call(params)
    response[0].must_equal 302

    article_params.each_with_index do |hash, index|
      _article = article_repo.find(hash['article_id'].to_i)
      _article.number.must_equal numbers[index].to_i
    end
  end

  it 'is rejected' do
    numbers = ["1", "1", "3"].shuffle
    articles.each { |article|
      article_repo.update(article.id, meeting_id: meeting.id)
    }
    article_params = articles.sample(3).map.with_index { |article, index| {'article_id' => "#{article.id}", 'number' => numbers[index]} }
    params = {id: meeting.id, meeting: {articles: article_params} }

    response = action.call(params)
    response[0].must_equal 422
  end
end
