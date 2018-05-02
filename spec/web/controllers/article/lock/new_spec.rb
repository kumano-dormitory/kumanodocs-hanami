require 'spec_helper'
require_relative '../../../../../apps/web/controllers/article/lock/new'

describe Web::Controllers::Article::Lock::New do
  let(:author) { Author.new(id: rand(1..5), lock: nil) }
  let(:article) { Article.new(id: rand(1..5), author_id: author.id, author: author) }

  it 'is successful' do
    article_repo = MiniTest::Mock.new.expect(:find_with_relations, article, [article.id])
    action = Web::Controllers::Article::Lock::New.new(
      article_repo: article_repo
    )
    response = action.call({article_id: article.id})

    response[0].must_equal 200
    article_repo.verify.must_equal true
    action.locked.must_equal false
  end
end
