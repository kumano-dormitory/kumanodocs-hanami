require 'spec_helper'

describe Admin::Controllers::Meeting::Article::Comment::Update do
  describe 'when user is logged in' do
    def assert_successful(params, comment_repo, vote_result_repo)
      action = Admin::Controllers::Meeting::Article::Comment::Update.new(
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [article.id]),
        block_repo: MiniTest::Mock.new.expect(:find, block, [block.id]),
        comment_repo: comment_repo, vote_result_repo: vote_result_repo,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:comment_update, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(params)

      _(response[0]).must_equal 302
      _(comment_repo.verify).must_equal true if comment_repo
      _(vote_result_repo.verify).must_equal true if vote_result_repo
    end

    def assert_invalid_params(invalid_params_merged)
      comment_repo = MiniTest::Mock.new.expect(:find, comment, [comment.article_id, comment.block_id])
      action = Admin::Controllers::Meeting::Article::Comment::Update.new(
        article_repo: MiniTest::Mock.new.expect(:find_with_relations, article, [article.id]),
        block_repo: MiniTest::Mock.new.expect(:find, block, [block.id]),
        comment_repo: comment_repo, vote_result_repo: nil,
        admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = valid_params_with_vote.deep_merge(invalid_params_merged)
      response = action.call(invalid_params)

      _(response[0]).must_equal 422
      _(action.comment).must_equal comment
      _(comment_repo.verify).must_equal true
    end

    let(:comment) { Comment.new(id: rand(1..100), article_id: rand(1..100), block_id: rand(1..9)) }
    let(:article) { Article.new(id: comment.article_id, author: Author.new(name: Faker::Name.name), categories: categories) }
    let(:categories) { [Category.new(id: rand(1..4), name: '採決', require_content: true)] }
    let(:block) { Block.new(id: comment.block_id) }
    let(:valid_params) {{
      article_id: comment.article_id,
      block_id: comment.block_id,
      comment: {
        body: Faker::Lorem.paragraphs.join
      }
    }}
    let(:check_params_comment) {{
      article_id: comment.article_id, block_id: comment.block_id, body: valid_params[:comment][:body]
    }}
    let(:vote) { {agree: rand(10..30), disagree: rand(10..30), onhold: rand(1..10)} }
    let(:vote_result) { VoteResult.new(id: rand(1..100), **vote) }
    let(:valid_params_with_vote) {{
      article_id: comment.article_id,
      block_id: comment.block_id,
      comment: {
        body: valid_params[:comment][:body],
        **vote,
      }
    }}
    let(:check_params_vote) {{ article_id: comment.article_id, block_id: comment.block_id, **vote }}

    it 'is successful create comment' do
      comment_repo = MiniTest::Mock.new.expect(:find, nil, [comment.article_id, comment.block_id])
                                       .expect(:create, nil, [check_params_comment.merge(crypt_password: '1')])
      assert_successful(valid_params, comment_repo, nil)
    end

    it 'is successful update comment' do
      comment_repo = MiniTest::Mock.new.expect(:find, comment, [comment.article_id, comment.block_id])
                                       .expect(:update, nil, [comment.id, check_params_comment])
      assert_successful(valid_params, comment_repo, nil)
    end

    it 'is successful create vote_result' do
      comment_repo = MiniTest::Mock.new.expect(:find, comment, [comment.article_id, comment.block_id])
                                       .expect(:update, nil, [comment.id, check_params_comment])
      vote_result_repo = MiniTest::Mock.new.expect(:find, nil, [comment.article_id, comment.block_id])
                                           .expect(:create, nil, [check_params_vote.merge(crypt_password: '1')])
      assert_successful(valid_params_with_vote, comment_repo, vote_result_repo)
    end

    it 'is successful update vote_result' do
      comment_repo = MiniTest::Mock.new.expect(:find, comment, [comment.article_id, comment.block_id])
                                       .expect(:update, nil, [comment.id, check_params_comment])
      vote_result_repo = MiniTest::Mock.new.expect(:find, vote_result, [comment.article_id, comment.block_id])
                                           .expect(:update, nil, [vote_result.id, check_params_vote])
      assert_successful(valid_params_with_vote, comment_repo, vote_result_repo)
    end

    it 'is validation error' do
      assert_invalid_params({comment: {body: nil}})
      assert_invalid_params({comment: {agree: -1}})
      assert_invalid_params({comment: {disagree: -1}})
      assert_invalid_params({comment: {onhold: -1}})
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Meeting::Article::Comment::Update.new(
        article_repo: nil, block_repo: nil, comment_repo: nil, vote_result_repo: nil,
        admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
