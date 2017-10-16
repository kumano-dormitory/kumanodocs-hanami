require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/update'

describe Admin::Controllers::Meeting::Article::Update do
  def assert_invalid_params(invalid_params_merged)
    action = Admin::Controllers::Meeting::Article::Update.new(
      meeting_repo: MiniTest::Mock.new.expect(:in_time, [Meeting.new(id: rand(1..5))]),
      category_repo: MiniTest::Mock.new.expect(:all, [Category.new(id: rand(1..5))])
    )
    invalid_params = valid_params.deep_merge(invalid_params_merged)

    response = action.call(invalid_params)
    # ステータスコードで失敗と判断する
    response[0].must_equal 422
    # TODO: エラー内容のチェック
  end

  let(:category_repo) { CategoryRepository.new }
  let(:categories_params) { category_repo.all.sample(2).map { |category| category.id } }
  let(:valid_params) {
    {
      article: {
        meeting_id: rand(1..5),
        categories: categories_params,
        title: Faker::Book.title,
        author: { name: Faker::Name.name },
        body: Faker::Lorem.paragraphs.join },
      id: rand(1..5)
    }
  }

  it 'is successful' do
    article = Article.new(
      id: valid_params[:id],
      meeting_id: valid_params[:article][:meeting_id],
      author_id: rand(1..5)
    )
    categories_params_hash = categories_params.map { |category_id| {category_id: category_id} }
    # レポジトリのモックを作成し、更新用メソッドが呼ばれたことを確認する
    article_repo = MiniTest::Mock.new.expect(
      :find, article, [valid_params[:id]]
    ).expect(
      :update_categories, nil, [article, categories_params_hash]
    ).expect(
      :update, nil, [valid_params[:id], valid_params[:article]]
    )
    author_repo = MiniTest::Mock.new.expect(
      :update, nil, [article.author_id, valid_params[:article][:author]]
    )

    action = Admin::Controllers::Meeting::Article::Update.new(article_repo: article_repo, author_repo: author_repo)
    response = action.call(valid_params)

    # articleを更新するメソッドが呼ばれたこと
    article_repo.verify.must_equal true
    author_repo.verify.must_equal true

    # リダイレクトされること
    response[0].must_equal 302
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
