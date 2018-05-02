require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/update'

describe Web::Controllers::Article::Update do
  def assert_invalid_params(invalid_params_merged)
    meeting_repo_mock = MiniTest::Mock.new.expect(:in_time, [Meeting.new(id: rand(1..5))])
    category_repo_mock = MiniTest::Mock.new.expect(:all, [Category.new(id: rand(1..5))])
    action = Web::Controllers::Article::Update.new(
      meeting_repo: meeting_repo_mock,
      category_repo: category_repo_mock
    )
    invalid_params = valid_params.deep_merge(invalid_params_merged)

    response = action.call(invalid_params)
    response[0].must_equal 422
    meeting_repo_mock.verify.must_equal true
    category_repo_mock.verify.must_equal true
  end

  let(:article) { create(:article) }
  let(:article_repo) { ArticleRepository.new }
  let(:author_repo) { AuthorRepository.new }
  let(:valid_params) {
    {
      id: article.id,
      article: {
        meeting_id: rand(1..5),
        categories: [1,2,3,4].sample(2),
        title: Faker::Book.title,
        body: Faker::Lorem.paragraphs.join,
        author: {name: Faker::Name.name},
        get_lock: false
      }
    }
  }

  it 'is successful' do
    lock_key = author_repo.lock(article.author_id, '')
    article_with_author = article_repo.find_with_relations(article.id)
    category_params = valid_params[:article][:categories].map{ |id| {category_id: id} }

    article_repo_mock = MiniTest::Mock.new.expect(
      :find_with_relations, article_with_author, [valid_params[:id]]
    ).expect(
      :update_categories, nil, [article_with_author, category_params]
    ).expect(
      :update, nil, [article.id, valid_params[:article]]
    )
    author_repo_mock = MiniTest::Mock.new.expect(
      :update, nil, [article.author_id, valid_params[:article][:author]]
    ).expect(
      :release_lock, nil, [article.author_id]
    )
    action = Web::Controllers::Article::Update.new(
      article_repo: article_repo_mock,
      author_repo: author_repo_mock
    )
    params = valid_params.merge("HTTP_COOKIE"=>"article_lock_key=#{lock_key}")
    response = action.call(params)

    response[0].must_equal 302
    article_repo_mock.verify.must_equal true
    author_repo_mock.verify.must_equal true
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
  end
end
