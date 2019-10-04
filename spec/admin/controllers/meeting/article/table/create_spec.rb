require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Table::Create do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id, Hash])
      action = Admin::Controllers::Meeting::Article::Table::Create.new(
        table_repo: nil, article_repo: article_repo, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = valid_params.deep_merge(invalid_params_merged)
      response = action.call(invalid_params)

      response[0].must_equal 422
      action.article.must_equal article
      article_repo.verify.must_equal true
    end

    let(:table) { Table.new(id: rand(1..100), article: article) }
    let(:article) { Article.new(id: rand(1..100), meeting_id: rand(1..50), author: Author.new(name: Faker::Name.name))}
    let(:valid_params) {{
      meeting_id: article.meeting_id,
      article_id: article.id,
      table: {
        caption: Faker::Book.title,
        tsv: Faker::Lorem.paragraphs.join,
      },
    }}
    let(:check_params) {{
      article_id: valid_params[:article_id],
      caption: valid_params[:table][:caption],
      csv: valid_params[:table][:tsv]
    }}

    it 'is successful update table' do
      table_repo = MiniTest::Mock.new.expect(:create, table, [check_params])
      action = Admin::Controllers::Meeting::Article::Table::Create.new(
        table_repo: table_repo,
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [article.id, Hash]),
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:table_create, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      response[0].must_equal 302
      table_repo.verify.must_equal true
    end

    it 'is validation error' do
      assert_invalid_params({table: {caption: nil}})
      assert_invalid_params({table: {caption: ''}})
      assert_invalid_params({table: {caption: 10}})
      assert_invalid_params({table: {tsv: nil}})
      assert_invalid_params({table: {tsv: ''}})
      assert_invalid_params({table: {tsv: -10}})
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Table::Create.new(
        table_repo: nil, article_repo: nil, admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
