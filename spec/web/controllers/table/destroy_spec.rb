require_relative '../../../spec_helper'

describe Web::Controllers::Table::Destroy do
  describe 'when user is logged in' do
    let(:article) { Article.new(id: rand(1..5), author: author) }
    let(:author) { Author.new(id: rand(1..100), crypt_password: crypt_password) }
    let(:password) { Faker::Internet.password }
    let(:crypt_password) { Author.crypt(password) }
    let(:table) { Table.new(id: rand(1..100), article_id: article.id, article: article) }
    let(:valid_params) {{
      id: table.id,
      table: {
        article_passwd: password,
        confirm: true,
      }
    }}

    it 'is successful' do
      table_repo = Minitest::Mock.new.expect(:find_with_relations, table, [table.id])
                                     .expect(:delete, nil, [table.id])
      action = Web::Controllers::Table::Destroy.new(
        table_repo: table_repo,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil])
      )
      response = action.call(valid_params)

      _(response[0]).must_equal 302
      _(table_repo.verify).must_equal true
    end

    it 'is required confirmation' do
      table_repo = Minitest::Mock.new.expect(:find_with_relations, table, [table.id])
      action = Web::Controllers::Table::Destroy.new(
        table_repo: table_repo,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil])
      )
      params_without_confirm = valid_params.deep_merge({table: {confirm: nil}})
      response = action.call(params_without_confirm)

      _(response[0]).must_equal 422
      _(action.table).must_equal table
      _(table_repo.verify).must_equal true
    end

    it 'is rejected by auth failure' do
      table_repo = Minitest::Mock.new.expect(:find_with_relations, table, [table.id])
      action = Web::Controllers::Table::Destroy.new(
        table_repo: table_repo,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil])
      )
      params_with_invalid_pass = valid_params.deep_merge({table: {article_passwd: Faker::Internet.password}})
      response = action.call(params_with_invalid_pass)

      _(response[0]).must_equal 401
      _(action.table).must_equal table
      _(table_repo.verify).must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    let(:action) { Web::Controllers::Table::Destroy.new(authenticator: authenticator) }

    it 'is redirected' do
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
