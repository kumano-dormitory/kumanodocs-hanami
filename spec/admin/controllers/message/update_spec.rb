require 'spec_helper'

describe Admin::Controllers::Message::Update do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      action = Admin::Controllers::Message::Update.new(
        comment_repo: MiniTest::Mock.new.expect(:find_with_relations, comment, [comment.id]),
        message_repo: MiniTest::Mock.new.expect(:find, msg, [msg.id])
                                        .expect(:by_article, [msg], [article.id]),
        article_repo: nil, admin_history_repo: nil,
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = valid_params.deep_merge(invalid_params_merged)
      response = action.call(invalid_params)

      response[0].must_equal 422
      action.comment.must_equal comment
      action.message.must_equal msg
      action.messages.must_equal({comment.id => [msg]})
    end

    let(:article) { Article.new(id: rand(1..100), meeting_id: rand(1..50), author_id: author.id) }
    let(:author) { Author.new(id: rand(1..100)) }
    let(:comment) { Comment.new(id: rand(1..100), article_id: article.id, block: Block.new(name: Faker::Name.name)) }
    let(:msg) { Message.new(id: rand(1..100), comment_id: comment.id) }
    let(:valid_params) {{
      id: msg.id,
      article_id: article.id,
      comment_id: comment.id,
      message: {
        send_by_article_author: [true, false].sample,
        body: Faker::Lorem.paragraphs.join,
      },
    }}
    let(:check_params) { valid_params[:message] }

    it 'is successful' do
      message_repo = MiniTest::Mock.new.expect(:find, msg, [msg.id])
                                       .expect(:update, msg, [msg.id, check_params])
      action = Admin::Controllers::Message::Update.new(
        article_repo: MiniTest::Mock.new.expect(:find, article, [article.id]),
        comment_repo: MiniTest::Mock.new.expect(:find_with_relations, comment, [comment.id]),
        message_repo: message_repo,
        admin_history_repo: MiniTest::Mock.new.expect(:add, nil, [:message_update, String]),
        authenticator: MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      response[0].must_equal 302
      message_repo.verify.must_equal true
    end

    it 'is validation error' do
      assert_invalid_params({message: nil})
      assert_invalid_params({message: ""})
      assert_invalid_params({message: []})
      assert_invalid_params({message: {send_by_article_author: nil}})
      assert_invalid_params({message: {send_by_article_author: "abc"}})
      assert_invalid_params({message: {send_by_article_author: [-1, 2].sample}})
      assert_invalid_params({message: {body: nil}})
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { MiniTest::Mock.new.expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, MiniTest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Message::Update.new(
        article_repo: nil, comment_repo: nil, message_repo: nil, admin_history_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(params)
      response[0].must_equal 302
    end
  end
end
