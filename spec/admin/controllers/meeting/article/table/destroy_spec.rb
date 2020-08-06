require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Table::Destroy do
  describe 'when user is logged in' do
    let(:table) { Table.new(id: rand(1..100), article_id: article.id, article: article) }
    let(:article) { Article.new(id: rand(1..100), meeting_id: rand(1..50), author: Author.new(name: Faker::Name.name)) }
    let(:valid_params) {{
      id: table.id,
      table: { confirm: true },
    }}
    let(:params_without_confirm) {{ id: table.id }}

    it 'is successful delete comment' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
                                     .expect(:delete, nil, [table.id])
      action = Admin::Controllers::Meeting::Article::Table::Destroy.new(
        table_repo: table_repo,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:table_destroy, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      _(response[0]).must_equal 302

      _(table_repo.verify).must_equal true
    end

    it 'is successful for confirm' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
      action = Admin::Controllers::Meeting::Article::Table::Destroy.new(
        table_repo: table_repo, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params_without_confirm)
      _(response[0]).must_equal 200
      _(action.table).must_equal table
      _(table_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Table::Destroy.new(
        table_repo: nil, admin_history_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
