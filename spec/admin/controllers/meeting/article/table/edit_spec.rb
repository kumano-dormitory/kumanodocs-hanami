require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Table::Edit do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:table) { Table.new(id: rand(1..100)) }
    let(:params) { { id: table.id } }

    it 'is successful' do
      action = Admin::Controllers::Meeting::Article::Table::Edit.new(
        table_repo: MiniTest::Mock.new.expect(:find_with_relations, table, [table.id]),
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.table).must_equal table
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Table::Edit.new(
        table_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
