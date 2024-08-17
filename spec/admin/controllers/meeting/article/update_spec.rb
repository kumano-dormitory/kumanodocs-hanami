require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/update'

describe Admin::Controllers::Meeting::Article::Update do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      meeting_repo = Minitest::Mock.new.expect(:desc_by_date, [Meeting.new(id: rand(1..5))])
      action = Admin::Controllers::Meeting::Article::Update.new(
        meeting_repo: meeting_repo,
        category_repo: Minitest::Mock.new.expect(:all, [Category.new(id: rand(1..5))]),
        article_repo: Minitest::Mock.new.expect(:of_recent, [Article.new(id: rand(1..100))], [Hash]),
        author_repo: nil, article_reference_repo: nil, admin_history_repo: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = valid_params.deep_merge(invalid_params_merged)

      response = action.call(invalid_params)
      # ステータスコードで失敗と判断する
      _(response[0]).must_equal 422
      # TODO: エラー内容のチェック
      _(meeting_repo.verify).must_equal true
    end

    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]) }
    let(:valid_params) {
      {
        id: rand(1..100),
        article: {
          meeting_id: rand(1..50),
          categories: [1, 3],
          title: Faker::Book.title,
          body: Faker::Lorem.paragraphs.join,
          format: [true, false].sample,
          author: { name: Faker::Name.name },
          same_refs_selected: [rand(1..100), rand(1..100), rand(1..100)],
          other_refs_selected: [rand(1..100), rand(1..100), rand(1..100)],
        }
      }
    }

    it 'is successful' do
      article = Article.new(
        id: valid_params[:id],
        meeting_id: valid_params[:article][:meeting_id],
        author_id: rand(1..100),
        categories: [Category.new(id: 1), Category.new(id: 3)],
      )
      category_repo = Minitest::Mock.new.expect(:find, article.categories[0], [1])
                                        .expect(:find, article.categories[1], [3])
      categories_params_hash = valid_params[:article][:categories].map { |id| {category_id: id, extra_content: nil} }
      # レポジトリのモックを作成し、更新用メソッドが呼ばれたことを確認する
      article_repo = Minitest::Mock.new.expect(
        :find_with_relations, article, [valid_params[:id], Hash]
      ).expect(
        :update_categories, nil, [article, categories_params_hash]
      ).expect(
        :update, article, [valid_params[:id], valid_params[:article].merge(format: (valid_params[:article][:format] ? 1 : 0))]
      )
      author_repo = Minitest::Mock.new.expect(:update, nil, [article.author_id, valid_params[:article][:author]])
      article_ref_repo = Minitest::Mock.new.expect(:update_refs, nil,
        [article.id, valid_params[:article][:same_refs_selected], valid_params[:article][:other_refs_selected]]
      )

      action = Admin::Controllers::Meeting::Article::Update.new(
        meeting_repo: nil, article_repo: article_repo, category_repo: category_repo,
        author_repo: author_repo, article_reference_repo: article_ref_repo,
        admin_history_repo: Minitest::Mock.new.expect(:add, nil, [:article_update, String]),
        authenticator: authenticator,
      )
      response = action.call(valid_params)

      # articleを更新するメソッドが呼ばれたこと
      _(article_repo.verify).must_equal true
      _(author_repo.verify).must_equal true
      _(article_ref_repo.verify).must_equal true

      # リダイレクトされること
      _(response[0]).must_equal 302
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

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Update.new(
        meeting_repo: nil, article_repo: nil, category_repo: nil, author_repo: nil,
        article_reference_repo: nil, admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
