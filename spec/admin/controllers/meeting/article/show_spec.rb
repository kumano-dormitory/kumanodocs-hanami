require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Show do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:article) { Article.new(id: rand(1..100)) }
    let(:blocks) { [Block.new(id: rand(1..10))] }
    let(:comment) { Comment.new(id: rand(1..100)) }
    let(:messages) { [Message.new(id: rand(1..100), comment_id: comment.id)] }
    let(:article_refs) { [ArticleReference.new(article_old_id: rand(1..100), article_new_id: article.id)] }
    let(:params) { {id: article.id} }

    it 'is successful' do
      action = Admin::Controllers::Meeting::Article::Show.new(
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [article.id]),
        block_repo: MiniTest::Mock.new.expect(:all, blocks),
        message_repo: MiniTest::Mock.new.expect(:by_article, messages, [article.id]),
        article_reference_repo: MiniTest::Mock.new.expect(:find_refs, article_refs, [article.id]),
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 200
      _(action.article).must_equal article
      _(action.blocks).must_equal blocks
      _(action.messages).must_equal({comment.id => messages})
      _(action.article_refs).must_equal article_refs
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Show.new(
        article_repo: nil, block_repo: nil, message_repo: nil, article_reference_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
