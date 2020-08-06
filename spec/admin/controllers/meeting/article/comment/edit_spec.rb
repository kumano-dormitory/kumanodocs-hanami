require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Comment::Edit do
  describe 'when user is logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]) }
    let(:comment) { Comment.new(id: rand(1..50), article_id: rand(1..100), block_id: rand(1..9)) }
    let(:article) { Article.new(id: comment.article_id, categories: categories) }
    let(:categories) { [Category.new(id: rand(1..4), require_content: true, name: '採決')] }
    let(:block) { Block.new(id: comment.block_id) }
    let(:vote_result) { VoteResult.new(id: rand(1..100)) }
    let(:params) { { article_id: comment.article_id, block_id: comment.block_id } }

    it 'is successful' do
      action = Admin::Controllers::Meeting::Article::Comment::Edit.new(
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [article.id]),
        block_repo: MiniTest::Mock.new.expect(:find, block, [comment.block_id]),
        comment_repo: MiniTest::Mock.new.expect(:find, comment, [comment.article_id, comment.block_id]),
        vote_result_repo: MiniTest::Mock.new.expect(:find, vote_result, [comment.article_id, comment.block_id]),
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 200

      _(action.article).must_equal article
      _(action.block).must_equal block
      _(action.comment).must_equal comment
      _(action.vote_result).must_equal vote_result
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Comment::Edit.new(
        article_repo: nil, block_repo: nil, comment_repo: nil, vote_result_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
