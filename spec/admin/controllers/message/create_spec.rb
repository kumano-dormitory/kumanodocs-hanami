require 'spec_helper'

describe Admin::Controllers::Message::Create do
  describe 'when user is logged in' do
    def assert_invalid_params(invalid_params_merged)
      action = Admin::Controllers::Message::Create.new(
        comment_repo: Minitest::Mock.new.expect(:find_with_relations, comment, [comment.id]),
        message_repo: Minitest::Mock.new.expect(:by_article, [msg], [article.id]),
        article_repo: nil, admin_history_repo: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      invalid_params = valid_params.deep_merge(invalid_params_merged)
      response = action.call(invalid_params)
      _(response[0]).must_equal 422
      _(action.comment).must_equal comment
      _(action.messages).must_equal({comment.id => [msg]})
    end

    let(:article) { Article.new(id: rand(1..100), meeting_id: rand(1..50), author_id: author.id) }
    let(:author) { Author.new(id: rand(1..100)) }
    let(:comment) { Comment.new(id: rand(1..100), article_id: article.id, block: Block.new(name: Faker::Name.name)) }
    let(:msg) { Message.new(id: rand(1..100), comment_id: comment.id) }
    let(:valid_params) {{
      article_id: article.id,
      comment_id: comment.id,
      message: {
        send_by_article_author: [true, false].sample,
        body: Faker::Lorem.paragraphs.join,
      },
    }}
    let(:check_params) {
      valid_params[:message].merge(
        {comment_id: comment.id, author_id: author.id}
      )
    }

    it 'is successful' do
      message_repo = Minitest::Mock.new.expect(:create, nil, [check_params])
      action = Admin::Controllers::Message::Create.new(
        article_repo: Minitest::Mock.new.expect(:find, article, [article.id]),
        comment_repo: Minitest::Mock.new.expect(:find_with_relations, comment, [comment.id]),
        message_repo: message_repo,
        admin_history_repo: Minitest::Mock.new.expect(:add, nil, [:message_create, String]),
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, User.new), [nil]),
      )
      response = action.call(valid_params)
      _(response[0]).must_equal 302
      _(message_repo.verify).must_equal true
    end

    it 'is validation error' do
      assert_invalid_params({message: ""})
      assert_invalid_params({message: []})
      assert_invalid_params({message: {send_by_article_author: nil}})
      assert_invalid_params({message: {send_by_article_author: "abc"}})
      assert_invalid_params({message: {send_by_article_author: [-1, 2].sample}})
      assert_invalid_params({message: {body: nil}})
    end
  end

  describe 'when user is not logged in' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:user, nil), [nil])
                                            .expect(:call, Minitest::Mock.new.expect(:user, nil), [nil]) }
    let(:params) { Hash[] }
    it 'is redirected' do
      action = Admin::Controllers::Message::Create.new(
        article_repo: nil, comment_repo: nil, message_repo: nil, admin_history_repo: nil,
        authenticator: authenticator,
      )
      response = action.call(params)
      _(response[0]).must_equal 302
    end
  end
end
