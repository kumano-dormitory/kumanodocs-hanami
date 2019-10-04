require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_number/update'

describe Admin::Controllers::ArticleNumber::Update do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      invalid_params = valid_params.deep_merge(invalid_params_merged)
      action = Admin::Controllers::ArticleNumber::Update.new(
        meeting_repo: Minitest::Mock.new.expect(:find_with_articles, meeting, [invalid_params[:id]]),
        article_repo: nil, admin_history_repo: nil,
        authenticator:  MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )

      response = action.call(invalid_params)
      response[0].must_equal 422
      #TODO: エラーの内容のチェック
      action.meeting.must_equal meeting
    end

    let(:meeting) { Meeting.new(id: valid_params[:id]) }
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
      article_repo = Minitest::Mock.new.expect(:update_number, nil, [valid_params[:id], articles_params])
      action = Admin::Controllers::ArticleNumber::Update.new(
        meeting_repo: nil,
        article_repo: article_repo,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:article_number_update, String]),
        authenticator:  MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      params = {id: valid_params[:id], meeting: {articles: articles_params} }

      response = action.call(params)
      response[0].must_equal 302
      article_repo.verify.must_equal true
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

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::ArticleNumber::Update.new(
        meeting_repo: nil, article_repo: nil, admin_history_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
