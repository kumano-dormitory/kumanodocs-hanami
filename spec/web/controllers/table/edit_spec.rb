require_relative '../../../spec_helper'

describe Web::Controllers::Table::Edit do
  describe 'when user is logged in' do
    let(:article) { Article.new(id: rand(1..5), author: author) }
    let(:author) { Author.new(id: rand(1..100), lock_key: lock_key) }
    let(:lock_key) { Author.generate_lock_key }
    let(:table) { Table.new(id: rand(1..100), article: article) }
    let(:params) { {id: table.id} }

    it 'is successful' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
      action = Web::Controllers::Table::Edit.new(
        table_repo: table_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil])
      )
      params_with_lock_key = params.merge("HTTP_COOKIE"=>"article_lock_key=#{lock_key}")
      response = action.call(params_with_lock_key)

      _(response[0]).must_equal 200
      _(action.table).must_equal table
      _(table_repo.verify).must_equal true
    end

    it 'is redirected to get lock key' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
      action = Web::Controllers::Table::Edit.new(
        table_repo: table_repo,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil])
      )
      params_without_lock_key = params.merge("HTTP_COOKIE"=>"")
      response = action.call(params_without_lock_key)

      _(response[0]).must_equal 302
      _(table_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Table::Edit.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
