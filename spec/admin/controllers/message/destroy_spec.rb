require 'spec_helper'

describe Admin::Controllers::Message::Destroy do
  describe 'when user is logged in' do
    let(:article) { Article.new(id: rand(1..100), meeting_id: rand(1..50)) }
    let(:comment) { Comment.new(id: rand(1..100), article_id: article.id, block: Block.new(name: 'A1'))}
    let(:msg) { Message.new(id: rand(1..100), comment_id: comment.id) }
    let(:valid_params) {{
      article_id: article.id,
      comment_id: comment.id,
      id: msg.id,
      message: { check: true },
    }}

    it 'is successful' do
      message_repo = MiniTest::Mock.new.expect(:by_article, [msg], [article.id])
                                       .expect(:find, msg, [msg.id])
                                       .expect(:delete, nil, [msg.id])
      action = Admin::Controllers::Message::Destroy.new(
        article_repo: MiniTest::Mock.new.expect(:find, article, [article.id]),
        comment_repo: MiniTest::Mock.new.expect(:find_with_relations, comment, [comment.id]),
        message_repo: message_repo,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:message_destroy, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      response[0].must_equal 302
      message_repo.verify.must_equal true
    end

    it 'needs destroy confirmation' do
      action = Admin::Controllers::Message::Destroy.new(
        article_repo: nil, admin_history_repo: nil,
        comment_repo: MiniTest::Mock.new.expect(:find_with_relations, comment, [comment.id]),
        message_repo: MiniTest::Mock.new.expect(:by_article, [msg], [article.id])
                                        .expect(:find, msg, [msg.id]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      params_without_confirm = valid_params.merge({message: nil})
      response = action.call(params_without_confirm)

      response[0].must_equal 200
      action.comment.must_equal comment
      action.messages.must_equal({msg.comment_id => [msg]})
      action.message.must_equal msg
    end

    let(:other_comment) { Comment.new(id: rand(200..300), article_id: article.id) }
    it 'is invalid params (does not match article & comment & message IDs)' do
      action = Admin::Controllers::Message::Destroy.new(
        article_repo: MiniTest::Mock.new.expect(:find, article, [article.id]),
        comment_repo: MiniTest::Mock.new.expect(:find_with_relations, other_comment, [other_comment.id]),
        message_repo: MiniTest::Mock.new.expect(:by_article, [msg], [article.id])
                                        .expect(:find, msg, [msg.id]),
        admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = valid_params.merge({comment_id: other_comment.id})
      response = action.call(invalid_params)

      response[0].must_equal 400
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Message::Destroy.new(
        article_repo: nil, comment_repo: nil, message_repo: nil,
        admin_history_repo: nil, authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
