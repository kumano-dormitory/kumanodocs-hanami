require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/create'

describe Admin::Controllers::Meeting::Article::Create do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      action = Admin::Controllers::Meeting::Article::Create.new(
        meeting_repo: MiniTest::Mock.new.expect(:find, meeting, [meeting.id]),
        category_repo: MiniTest::Mock.new.expect(:all, [Category.new(id: rand(1..5))]),
        article_repo: MiniTest::Mock.new.expect(:of_recent, [Article.new(id: rand(1..100))], [Hash]),
        article_reference_repo: nil, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = valid_params.deep_merge(invalid_params_merged)

      response = action.call(invalid_params)
      # ステータスコードで失敗と判断する
      response[0].must_equal 422
      # TODO: エラー内容のチェック
    end

    let(:meeting) { Meeting.new(id: rand(1..50)) }
    let(:valid_params) {
      password = Faker::Internet.password
      {
        meeting_id: meeting.id,
        article: {
          meeting_id: meeting.id,
          categories: [1, 3],
          checked: [true, false].sample,
          title: Faker::Book.title,
          body: Faker::Lorem.paragraphs.join,
          format: [true, false].sample,
          author: {
            name: Faker::Name.name,
            password: password,
            password_confirmation: password
          },
          same_refs_selected: [rand(1..100), rand(1..100), rand(1..100)],
          other_refs_selected: [rand(1..100), rand(1..100), rand(1..100)],
        }
      }
    }

    it 'is successful' do
      article = Article.new(id: rand(1..5), meeting_id: valid_params[:article][:meeting_id])
      article_repo = MiniTest::Mock.new.expect(
        :create_with_related_entities, article,
        [
          valid_params[:article][:author],
          valid_params[:article][:categories].map { |id| { category_id: id, extra_content: nil } },
          valid_params[:article].except(:author, :categories).merge(format: (valid_params[:article][:format] ? 1 : 0))
        ]
      )
      article_ref_repo = MiniTest::Mock.new.expect(
        :create_refs, nil, [article.id, valid_params[:article][:same_refs_selected], {same: true}]
      ).expect(
        :create_refs, nil, [article.id, valid_params[:article][:other_refs_selected], {same: false}]
      )
      action = Admin::Controllers::Meeting::Article::Create.new(
        article_repo: article_repo, meeting_repo: nil,
        category_repo: MiniTest::Mock.new.expect(:find, Category.new(id: 1), [1]).expect(:find, Category.new(id: 3), [3]),
        article_reference_repo: article_ref_repo,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:article_create, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)

      # articleを保存するメソッドが呼ばれたこと
      article_repo.verify.must_equal true
      article_ref_repo.verify.must_equal true

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

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Create.new(
        meeting_repo: nil, article_repo: nil, category_repo: nil, article_reference_repo: nil,
        admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
