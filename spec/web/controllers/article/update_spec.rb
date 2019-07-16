require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/update'

describe Web::Controllers::Article::Update do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      article_repo_mock = MiniTest::Mock.new.expect(:of_recent, [article], [Hash])
      meeting_repo_mock = MiniTest::Mock.new.expect(:in_time, [Meeting.new(id: rand(1..5))])
      category_repo_mock = MiniTest::Mock.new.expect(:all, [Category.new(id: rand(1..5))])
      action = Web::Controllers::Article::Update.new(
        article_repo: article_repo_mock, author_repo: nil, meeting_repo: meeting_repo_mock,
        category_repo: category_repo_mock, article_reference_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      invalid_params = valid_params.deep_merge(invalid_params_merged)

      response = action.call(invalid_params)
      response[0].must_equal 422
      action.recent_articles.must_equal [article]
      article_repo_mock.verify.must_equal true
      meeting_repo_mock.verify.must_equal true
      category_repo_mock.verify.must_equal true
    end

    let(:article) { Article.new(id: rand(1..100), meeting_id: meeting.id, meeting: meeting, author: author) }
    let(:meeting) { Meeting.new(id: rand(1..50), deadline: (Date.today + 30).to_time) }
    let(:author) { Author.new(id: rand(1..100), crypt_password: crypt_password, lock_key: lock_key) }
    let(:password) { Faker::Internet.password }
    let(:crypt_password) { Author.crypt(password) }
    let(:lock_key) { Faker::Internet.password }
    let(:categories) { [1,2,3,4].sample(2).map{|i| Category.new(id: i)} }
    let(:format_number) { [0, 1].sample }
    let(:valid_params) {
      {
        id: article.id,
        article: {
          meeting_id: meeting.id,
          categories: categories.map(&:id),
          title: Faker::Book.title,
          body: Faker::Lorem.paragraphs.join,
          format: (format_number == 1),
          author: {name: Faker::Name.name},
          get_lock: false
        }
      }
    }

    it 'is successful' do
      category_params = valid_params[:article][:categories].map{ |id| {category_id: id, extra_content: nil} }
      article_repo_mock = MiniTest::Mock.new.expect(
        :find_with_relations, article, [article.id]
      ).expect(
        :update_categories, nil, [article, category_params]
      ).expect(
        :update, nil, [article.id, valid_params[:article].merge(format: format_number)]
      )
      author_repo_mock = MiniTest::Mock.new.expect(
        :update, nil, [article.author_id, valid_params[:article][:author]]
      ).expect(
        :release_lock, nil, [article.author_id]
      )
      action = Web::Controllers::Article::Update.new(
        article_repo: article_repo_mock, author_repo: author_repo_mock,
        meeting_repo: MiniTest::Mock.new.expect(:find_most_recent, meeting),
        category_repo: MiniTest::Mock.new.expect(:find, categories[0], [categories[0].id])
                                         .expect(:find, categories[1], [categories[1].id]),
        article_reference_repo: MiniTest::Mock.new.expect(:update_refs, nil, [article.id, nil, nil]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      params = valid_params.merge("HTTP_COOKIE"=>"article_lock_key=#{lock_key}")
      response = action.call(params)

      response[0].must_equal 302
      article_repo_mock.verify.must_equal true
      author_repo_mock.verify.must_equal true
    end

    it 'is successful get lock' do
      category_params = valid_params[:article][:categories].map{ |id| {category_id: id, extra_content: nil} }
      params = valid_params.deep_merge({ article: { get_lock: true, password: password } })
      article_repo_mock = MiniTest::Mock.new.expect(
        :find_with_relations, article, [article.id]
      ).expect(
        :update_categories, nil, [article, category_params]
      ).expect(
        :update, nil, [article.id, params[:article].merge(format: format_number)]
      )
      author_repo_mock = MiniTest::Mock.new.expect(
        :update, nil, [article.author_id, params[:article][:author]]
      ).expect(
        :release_lock, nil, [article.author_id]
      )
      action = Web::Controllers::Article::Update.new(
        article_repo: article_repo_mock, author_repo: author_repo_mock,
        meeting_repo: MiniTest::Mock.new.expect(:find_most_recent, meeting),
        category_repo: MiniTest::Mock.new.expect(:find, categories[0], [categories[0].id])
                                         .expect(:find, categories[1], [categories[1].id]),
        article_reference_repo: MiniTest::Mock.new.expect(:update_refs, nil, [article.id, nil, nil]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params)

      response[0].must_equal 302
      article_repo_mock.verify.must_equal true
      author_repo_mock.verify.must_equal true
    end

    it 'is authentication error' do
      category_params = valid_params[:article][:categories].map{ |id| {category_id: id, extra_content: nil} }
      params = valid_params.deep_merge({ article: { get_lock: true, password: Faker::Internet.password } })
      article_repo_mock = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
                                            .expect(:of_recent, [article], [Hash])
      meeting_repo_mock = MiniTest::Mock.new.expect(:in_time, [Meeting.new(id: rand(1..5))])
      category_repo_mock = MiniTest::Mock.new.expect(:all, [Category.new(id: rand(1..5))])
      action = Web::Controllers::Article::Update.new(
        article_repo: article_repo_mock, author_repo: nil, meeting_repo: meeting_repo_mock,
        category_repo: category_repo_mock, article_reference_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params)

      response[0].must_equal 401
      action.confirm_update.must_equal true
      action.recent_articles.must_equal [article]
      article_repo_mock.verify.must_equal true
      meeting_repo_mock.verify.must_equal true
      category_repo_mock.verify.must_equal true
    end

    it 'is rejected' do
      assert_invalid_params(article: { title: nil })
      assert_invalid_params(article: { body: nil })
      assert_invalid_params(article: { meeting_id: "hoge" })
      assert_invalid_params(article: { meeting_id: nil })
      assert_invalid_params(article: { categories: [] })
      assert_invalid_params(article: { categories: nil })
      assert_invalid_params(article: { categories: "hoge" })
      assert_invalid_params(article: { author: { name: nil } })
      assert_invalid_params(article: { get_lock: nil})
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Article::Update.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
