require_relative '../../../spec_helper'

describe Web::Controllers::Table::Create do
  describe 'when user is logged in' do
    let(:meeting) { Meeting.new(id: rand(1..50), deadline: (Date.today + 30).to_time, date: (Date.today + 40)) }
    let(:articles) { [article] }
    let(:article) { Article.new(id: rand(1..100), author_id: author.id, author: author, meeting: meeting) }
    let(:author) { Author.new(id: rand(1..100), crypt_password: crypt_password) }
    let(:password) { Faker::Internet.password }
    let(:crypt_password) { Author.crypt(password) }
    let(:table) { Table.new(id: rand(1..100), article_id: article.id, article: article) }
    let(:valid_params) {{
      table: {
        article_id: article.id,
        article_passwd: password,
        caption: Faker::Book.title,
        tsv: Faker::Lorem.paragraphs.join,
      }
    }}
    let(:valid_params_check) {{
      article_id: valid_params[:table][:article_id],
      caption: valid_params[:table][:caption],
      csv: valid_params[:table][:tsv],
    }}
    let(:spec) { Specifications::Pdf.new(type: :table, data: {caption: valid_params[:table][:caption], csv: valid_params[:table][:tsv]}) }

    it 'is successful create table' do
      article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
      table_repo = MiniTest::Mock.new.expect(:create, nil, [valid_params_check])
      generate_pdf = MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:failure?, false), [spec])
      action = Web::Controllers::Table::Create.new(
        article_repo: article_repo, table_repo: table_repo,
        author_repo: MiniTest::Mock.new.expect(:release_lock, nil, [author.id]),
        generate_pdf_interactor: generate_pdf,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(valid_params)

      response[0].must_equal 302
      article_repo.verify.must_equal true
      table_repo.verify.must_equal true
      generate_pdf.verify.must_equal true
    end

    it 'is rejected by auth failure' do
      article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
                                       .expect(:before_deadline, articles)
      action = Web::Controllers::Table::Create.new(
        article_repo: article_repo, table_repo: nil, author_repo: nil, generate_pdf_interactor: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      params_with_wrong_pass = valid_params.deep_merge({table: {article_passwd: Faker::Internet.password}})
      response = action.call(params_with_wrong_pass)

      response[0].must_equal 401
      action.articles.must_equal articles
      article_repo.verify.must_equal true
    end

    it 'is validation error' do
      article_repo = MiniTest::Mock.new.expect(:before_deadline, articles)
      action = Web::Controllers::Table::Create.new(
        article_repo: article_repo, table_repo: nil, author_repo: nil, generate_pdf_interactor: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]),
      )
      invalid_params = valid_params.deep_merge({table: {caption: ""}})
      response = action.call(invalid_params)

      response[0].must_equal 422
      action.articles.must_equal articles
      article_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Table::Create.new(
        article_repo: nil, author_repo: nil, table_repo: nil, generate_pdf_interactor: nil, authenticator: authenticator
      )
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
