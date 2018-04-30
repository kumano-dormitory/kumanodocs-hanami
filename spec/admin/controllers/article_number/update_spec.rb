require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_number/update'

describe Admin::Controllers::ArticleNumber::Update do
  def assert_invalid_params(invalid_params_merged)
    invalid_params = valid_params.deep_merge(invalid_params_merged)
    action = Admin::Controllers::ArticleNumber::Update.new(
      meeting_repo: Minitest::Mock.new.expect(:find_with_articles, nil, [invalid_params[:id]])
    )

    response = action.call(invalid_params)
    response[0].must_equal 422
    #TODO: エラーの内容のチェック
  end

  let(:valid_params) {
    {
      id: rand(1..5),
      meeting: {
        articles: [
          {'article_id' => rand(1..5), 'number' => '1'},
          {'article_id' => rand(6..10), 'number' => '2'},
          {'article_id' => rand(10..15), 'number' => '3'},
        ]
      }
    }
  }

  it 'is successful' do
    numbers = ["1", "2", "3"].shuffle
    articles = [
      Article.new(id: rand(1..5), meeting_id: valid_params[:id]),
      Article.new(id: rand(6..10), meeting_id: valid_params[:id]),
      Article.new(id: rand(11..15), meeting_id: valid_params[:id]),
      Article.new(id: rand(16..20), meeting_id: valid_params[:id]),
      Article.new(id: rand(21..25), meeting_id: valid_params[:id])
    ]
    articles_params = articles.map{ |article| {'article_id' => "#{article.id}", 'number' => ""} }
    articles_params.sample(3).each.with_index do |article_params, index|
      article_params['number'] = numbers[index]
    end
    action = Admin::Controllers::ArticleNumber::Update.new(
      article_repo: Minitest::Mock.new.expect(:update_number, nil, [valid_params[:id], articles_params])
    )
    params = {id: valid_params[:id], meeting: {articles: articles_params} }

    response = action.call(params)
    response[0].must_equal 302
  end

  it 'is rejected' do
    assert_invalid_params(
      meeting: {articles: [
          {'article_id' => rand(1..5), 'number' => '1'},
          {'article_id' => rand(6..10), 'number' => '1'},
          {'article_id' => rand(10..15), 'number' => '2'},
        ]}
    )
    assert_invalid_params(
      meeting: {articles: [
          {'article_id' => rand(1..5), 'number' => '2'},
          {'article_id' => rand(6..10), 'number' => '3'},
          {'article_id' => rand(10..15), 'number' => '4'},
        ]}
    )
    assert_invalid_params(
      meeting: {articles: [
          {'article_id' => rand(1..5), 'number' => '1'},
          {'article_id' => rand(6..10), 'number' => '2'},
          {'article_id' => rand(10..15), 'number' => '4'},
        ]}
    )
  end
end
