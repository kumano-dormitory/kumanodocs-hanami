require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Search do
  describe 'when user is logged in' do
    def assert_successful(query, keywords_array, query_ret)
      action = Admin::Controllers::Meeting::Article::Search.new(
        article_repo: MiniTest::Mock.new.expect(:search_count, search_count, [keywords_array])
                        .expect(:search, articles, [keywords_array, page, limit]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
        limit: limit,
      )
      response = action.call({query: query, page: page})
      _(response[0]).must_equal 200
      _(action.articles).must_equal articles
      _(action.keywords).must_equal query_ret
      _(action.page).must_equal page
      _(action.max_page).must_equal ((search_count - 1) / limit + 1)
    end

    let(:articles) { [Article.new(id: rand(1..100))] }
    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:limit) { 20 }
    let(:search_count) { rand(1..100) }
    let(:page) { 1 }

    it 'is successful' do
      assert_successful("", [''], "")
      assert_successful("  ", [''], "")
      assert_successful("　", [''], "　")
      assert_successful('a b c ', ['a','b','c'], 'a b c ')
      assert_successful('あ　い　う', ['あ','い','う'], 'あ　い　う')
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Search.new(
        article_repo: nil, authenticator: authenticator, limit: nil,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
