require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/create'

describe Web::Controllers::Article::Create do
  describe 'when user is logged in' do
    let(:article) { Article.new(id: rand(1..5), meeting_id: valid_params[:article][:meeting_id]) }
    let(:meeting) { Meeting.new(id: valid_params[:article][:meeting_id], deadline: (Date.today + 30).to_time) }
    let(:meetings) { [Meeting.new(id: rand(1..5))] }
    let(:categories) { valid_params[:article][:categories].map{|id| Category.new(id: id, name: Faker::Creature::Cat.name)} }
    let(:author) { Author.new( author_params.merge(id: rand(1..5)) ) }
    let(:author_params) {
      password = Faker::Internet.password
      {
        name: Faker::Name.name,
        password: password,
        password_confirmation: password
      }
    }
    let(:format_number) { [0, 1].sample }
    let(:valid_params) {
      {
        article: {
          meeting_id: rand(1..5),
          categories: [1, 2, 4].sample(2), # 採決項目のデータを用意していないので,3に対応する「採決」を除く
          title: Faker::Book.title,
          body: Faker::Lorem.paragraphs.join,
          author: author_params,
          format: (format_number == 1),
        },
        action: 'post_article',
      }
    }
    let(:article_check_params) { valid_params[:article].merge(author_id: author.id, checked: true, format: format_number) }

    # TODO: 議案の作成処理をサービスとして実装してから、時間に関するロジックでテストを分ける
    it 'is successful' do
      categories_params = valid_params[:article][:categories].map{ |id| {category_id: id, extra_content: nil} }
      meeting_repo = Minitest::Mock.new.expect(:find, meeting, [meeting.id])
      category_repo = Minitest::Mock.new.expect(:find, categories[0], [valid_params[:article][:categories][0]])
                                        .expect(:find, categories[1], [valid_params[:article][:categories][1]])
                                        .expect(:find, categories[0], [valid_params[:article][:categories][0]])
                                        .expect(:find, categories[1], [valid_params[:article][:categories][1]])
      author_repo = Minitest::Mock.new.expect(
        :create_with_plain_password, author, [author_params[:name], author_params[:password]]
      )
      article_repo = Minitest::Mock.new.expect(
        :create, article, [article_check_params]
      ).expect(
        :add_categories, nil, [article, categories_params]
      )
      article_ref_repo = Minitest::Mock.new.expect(:create_refs, nil, [article.id, nil, {same: true}])
                                           .expect(:create_refs, nil, [article.id, nil, {same: false}])
      action = Web::Controllers::Article::Create.new(
        meeting_repo: meeting_repo, category_repo: category_repo,
        author_repo: author_repo, article_repo: article_repo, article_reference_repo: article_ref_repo,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(valid_params)

      _(response[0]).must_equal 302
      _(category_repo.verify).must_equal true
      _(author_repo.verify).must_equal true
      _(article_repo.verify).must_equal true
      _(article_ref_repo.verify).must_equal true
    end

    it 'is rejected' do
      meeting_repo = Minitest::Mock.new.expect(:in_time, meetings)
                                       .expect(:find_most_recent, meeting)
      category_repo = Minitest::Mock.new.expect(:all, categories)
      action = Web::Controllers::Article::Create.new(
        meeting_repo: meeting_repo,
        category_repo: category_repo,
        article_repo: Minitest::Mock.new.expect(:of_recent, [article], [Hash]),
        author_repo: nil, article_reference_repo: nil,
        authenticator: Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, true), [nil]),
      )
      response = action.call(valid_params.merge({action: nil}))

      _(response[0]).must_equal 422
      _(action.meetings).must_equal meetings
      _(action.next_meeting).must_equal meeting
      _(action.categories).must_equal categories
      _(meeting_repo.verify).must_equal true
      _(category_repo.verify).must_equal true
    end
  end

  describe 'when user is not loggedin' do
    let(:authenticator) { Minitest::Mock.new.expect(:call, Minitest::Mock.new.expect(:verification, false), [nil]) }
    it 'is redirected' do
      action = Web::Controllers::Article::Create.new(
        meeting_repo: nil, category_repo: nil, article_repo: nil, author_repo: nil,
        article_reference_repo: nil, authenticator: authenticator,
      )
      response = action.call({})
      _(response[0]).must_equal 302
    end
  end
end
