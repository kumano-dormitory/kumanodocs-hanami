require 'spec_helper'
require_relative '../../../../../apps/web/controllers/article/lock/new'

describe Web::Controllers::Article::Lock::New do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, true), [nil]) }
    let(:author) { Author.new(id: rand(1..5), lock_key: [nil, lock_key].sample) }
    let(:lock_key) { Author.generate_lock_key }
    let(:article) { Article.new(id: rand(1..5), author_id: author.id, author: author) }
    let(:params) {{
      article_id: article.id,
      table_id: [nil, rand(1..100)].sample,
    }}

    it 'is successful' do
      article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
      action = Web::Controllers::Article::Lock::New.new(
        article_repo: article_repo, authenticator: authenticator,
      )
      response = action.call(params)

      response[0].must_equal 200
      action.locked.must_equal (!author.lock_key.nil?)
      action.for_table.must_equal (!params[:table_id].nil?)
      if params[:table_id].nil?
        assert_nil action.table_id
      else
        action.table_id.must_equal params[:table_id]
      end
      article_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:verification, false), [nil]) }

    it 'is redirected' do
      action = Web::Controllers::Article::Lock::New.new(article_repo: nil, authenticator: authenticator)
      response = action.call({})
      response[0].must_equal 302
    end
  end
end
