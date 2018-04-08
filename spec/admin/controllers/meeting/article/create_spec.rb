require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/create'

describe Admin::Controllers::Meeting::Article::Create do
  def assert_invalid_params(invalid_params_merged)
    action = Admin::Controllers::Meeting::Article::Create.new(
      meeting_repo: MiniTest::Mock.new.expect(:in_time, [Meeting.new(id: rand(1..5))]),
      category_repo: MiniTest::Mock.new.expect(:all, [Category.new(id: rand(1..5))])
    )
    invalid_params = valid_params.deep_merge(invalid_params_merged)

    response = action.call(invalid_params)
    # ステータスコードで失敗と判断する
    response[0].must_equal 422
    # TODO: エラー内容のチェック
  end

  let(:valid_params) {
    meeting_id = rand(1..5)
    password = Faker::Internet.password
    {
      meeting_id: meeting_id,
      article: {
        meeting_id: meeting_id,
        categories: [1, 2, 3],
        title: Faker::Book.title,
        body: Faker::Lorem.paragraphs.join,
        author: {
          name: Faker::Name.name,
          password: password,
          password_confirmation: password
        }
      }
    }
  }

  it 'is successful' do
    article = Article.new(id: rand(1..5), meeting_id: valid_params[:article][:meeting_id])
    article_repo = MiniTest::Mock.new.expect(
      :create_with_related_entities, article,
      [
        valid_params[:article][:author],
        valid_params[:article][:categories].map { |id| { category_id: id } },
        valid_params[:article].except(:author, :categories)
      ]
    )
    action = Admin::Controllers::Meeting::Article::Create.new(article_repo: article_repo)

    response = action.call(valid_params)

    # articleを保存するメソッドが呼ばれたこと
    article_repo.verify.must_equal true

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
    assert_invalid_params(article: { author: { password: 'abcdefg', password_confirmation: '12345' } })
    assert_invalid_params(article: { author: { name: nil } })
  end
end
