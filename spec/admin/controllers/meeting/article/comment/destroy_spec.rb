require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Comment::Destroy do
  describe 'when user is logged in' do
    let(:comment) { Comment.new(id: rand(1..100), article_id: rand(1..100), block_id: rand(1..9)) }
    let(:article) { Article.new(id: comment.article_id, meeting_id: rand(1..50), author: Author.new(name: Faker::Name.name)) }
    let(:block) { Block.new(id: comment.block_id) }
    let(:valid_params) {{
      article_id: comment.article_id,
      block_id: comment.block_id,
      comment: { confirm_delete: true },
    }}
    let(:params_without_confirm) {{ article_id: comment.article_id, block_id: comment.block_id }}

    it 'is successful delete comment' do
      comment_repo = MiniTest::Mock.new.expect(:find, comment, [comment.article_id, comment.block_id])
                                       .expect(:delete, nil, [comment.id])
      action = Admin::Controllers::Meeting::Article::Comment::Destroy.new(
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [comment.article_id, Hash]),
        block_repo: MiniTest::Mock.new.expect(:find, block, [comment.block_id]),
        comment_repo: comment_repo,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:comment_destroy, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      response[0].must_equal 302

      comment_repo.verify.must_equal true
    end

    it 'is successful for confirm' do
      comment_repo = MiniTest::Mock.new.expect(:find, comment, [comment.article_id, comment.block_id])
      action = Admin::Controllers::Meeting::Article::Comment::Destroy.new(
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [comment.article_id, Hash]),
        block_repo: MiniTest::Mock.new.expect(:find, block, [comment.block_id]),
        comment_repo: comment_repo, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params_without_confirm)
      response[0].must_equal 200

      comment_repo.verify.must_equal true
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Comment::Destroy.new(
        article_repo: nil, block_repo: nil, comment_repo: nil, admin_history_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
