require_relative '../../../spec_helper'

describe Web::Controllers::Article::Search do
  describe 'when user is logged in' do
    def assert_successful_normal(query, keywords_array, query_ret)
      article_repo = Minitest::Mock.new.expect(
        :search_count, search_count, [keywords_array]
      ).expect(
        :search, articles, [keywords_array, page, limit]
      )
      action = Web::Controllers::Article::Search.new(
        article_repo: article_repo, category_repo: Minitest::Mock.new.expect(:all, categories),
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]),
        limit: limit,
      )
      response = action.call({search_article: {keywords: query}, page: page})

      _(response[0]).must_equal 200
      _(action.articles).must_equal articles
      _(action.keywords).must_equal query_ret
      _(action.page).must_equal page
      _(action.max_page).must_equal ((search_count - 1) / limit + 1)
      _(action.detail_search).must_equal false
      _(article_repo.verify).must_equal true
    end

    def assert_successful_detail(query, keywords)
      article_repo = Minitest::Mock.new.expect(
        :search_count, search_count, [keywords, {detail_search: true}]
      ).expect(
        :search, articles, [keywords, page, limit, {detail_search: true}]
      )
      action = Web::Controllers::Article::Search.new(
        article_repo: article_repo, category_repo: Minitest::Mock.new.expect(:all, categories),
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]),
        limit: limit,
      )
      params = {page: page, search_article: {**query, detail_search: true}}
      response = action.call(params)

      _(response[0]).must_equal 200
      _(action.articles).must_equal articles
      _(action.categories).must_equal categories
      _(action.keywords).must_equal keywords
      _(action.page).must_equal page
      _(action.max_page).must_equal ((search_count - 1) / limit + 1)
      _(action.detail_search).must_equal true
      _(article_repo.verify).must_equal true
    end

    let(:articles) { [Article.new(id: rand(1..100))] }
    let(:categories) { [Category.new(id: rand(1..100))] }
    let(:search_count) { rand(1..100) }
    let(:page) { 1 }
    let(:limit) { 20 }

    it 'is successful search' do
      assert_successful_normal("", [''], "")
      assert_successful_normal("  ", [''], "  ")
      assert_successful_normal("　", [''], "　")
      assert_successful_normal("a b c ", ['a','b','c'], "a b c ")
      assert_successful_normal("あ　い　う", ['あ','い','う'], "あ　い　う")
    end

    it 'is successful detail search' do
      params1 = {title: "abc", body: "def", author: "ghi"}
      assert_successful_detail(params1, {**params1, categories: []})
      params2 = {title: "jkl", body: "mno", author: "pqr", categories: [1, 2, 3].sample(2)}
      assert_successful_detail(params2, params2)
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Article::Search.new(
        article_repo: nil, category_repo: nil, authenticator: authenticator
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
