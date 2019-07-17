require_relative '../../../spec_helper'

describe Web::Controllers::Table::Update do
  describe 'when user is logged in' do
    let(:meeting) { Meeting.new(id: rand(1..50), deadline: (Date.today + 30).to_time, date: (Date.today + 40)) }
    let(:articles) { [article] }
    let(:article) { Article.new(id: rand(1..100), author_id: author.id, author: author, meeting: meeting) }
    let(:author) { Author.new(id: rand(1..100), crypt_password: crypt_password, lock_key: lock_key) }
    let(:password) { Faker::Internet.password }
    let(:crypt_password) { Author.crypt(password) }
    let(:lock_key) { Author.generate_lock_key }
    let(:table) { Table.new(id: rand(1..100), article_id: article.id, article: article) }
    let(:valid_params) {{
      id: table.id,
      table: {
        get_lock: false,
        caption: Faker::Book.title,
        tsv: Faker::Lorem.paragraphs.join,
      }
    }}
    let(:params_for_get_lock) { valid_params.deep_merge({table: {get_lock: true, article_passwd: password}}) }
    let(:check_params) {{
      caption: valid_params[:table][:caption],
      csv: valid_params[:table][:tsv],
    }}

    it 'is successful update table' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
                                     .expect(:update, nil, [table.id, check_params])
      action = Web::Controllers::Table::Update.new(
        table_repo: table_repo,
        author_repo: MiniTest::Mock.new.expect(:release_lock, nil, [author.id]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      params_with_lock_key = valid_params.merge("HTTP_COOKIE"=>"article_lock_key=#{lock_key}")
      response = action.call(params_with_lock_key)

      response[0].must_equal 302
      table_repo.verify.must_equal true
    end

    it 'is successful get lock and update' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
                                     .expect(:update, nil, [table.id, check_params])
      action = Web::Controllers::Table::Update.new(
        table_repo: table_repo,
        author_repo: MiniTest::Mock.new.expect(:release_lock, nil, [author.id]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(params_for_get_lock)

      response[0].must_equal 302
      table_repo.verify.must_equal true
    end

    it 'is rejected by auth failure' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
                                     .expect(:find_with_relations, table, [table.id])
      action = Web::Controllers::Table::Update.new(
        table_repo: table_repo, author_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      invalid_pass_params = params_for_get_lock.deep_merge({table: {article_passwd: Faker::Internet.password}})
      response = action.call(invalid_pass_params)

      response[0].must_equal 401
      action.table.must_equal table
      table_repo.verify.must_equal true
    end

    it 'is validation error' do
      table_repo = MiniTest::Mock.new.expect(:find_with_relations, table, [table.id])
      action = Web::Controllers::Table::Update.new(
        table_repo: table_repo, author_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      invalid_params = valid_params.deep_merge({table: {caption: ""}})
      response = action.call(invalid_params)

      response[0].must_equal 422
      action.table.must_equal table
      table_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Table::Update.new(
        author_repo: nil, table_repo: nil, authenticator: authenticator,
      )
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
