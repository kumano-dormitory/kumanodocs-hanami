require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Table::Update do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
      action = Admin::Controllers::Meeting::Article::Table::Update.new(
        table_repo: table_repo, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = valid_params.deep_merge(invalid_params_merged)
      response = action.call(invalid_params)

      _(response[0]).must_equal 422
      _(action.table).must_equal table
      _(table_repo.verify).must_equal true
    end

    let(:table) { Table.new(id: rand(1..100), article: article) }
    let(:article) { Article.new(id: rand(1..100), meeting_id: rand(1..50), title: Faker::Book.title)}
    let(:valid_params) {{
      id: table.id,
      table: {
        caption: Faker::Book.title,
        tsv: Faker::Lorem.paragraphs.join,
      },
    }}
    let(:check_params) {{ caption: valid_params[:table][:caption], csv: valid_params[:table][:tsv] }}

    it 'is successful update table' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
                                     .expect(:update, table, [table.id, check_params])
      action = Admin::Controllers::Meeting::Article::Table::Update.new(
        table_repo: table_repo,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:table_update, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      _(response[0]).must_equal 302
      _(table_repo.verify).must_equal true
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
      action = Admin::Controllers::Meeting::Article::Table::Update.new(
        table_repo: nil, admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
