require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/create'

describe Web::Controllers::Article::Create do
  let(:article) { Article.new(id: rand(1..5), meeting_id: valid_params[:article][:meeting_id]) }
  let(:meetings) { [Meeting.new(id: rand(1..5))] }
  let(:categories) { [Category.new(id: rand(1..5))] }
  let(:author) { Author.new( author_params.merge(id: rand(1..5)) ) }
  let(:params) { Hash[] }
  let(:author_params) {
    password = Faker::Internet.password
    {
      name: Faker::Name.name,
      password: password,
      password_confirmation: password
    }
  }
  let(:valid_params) {
    {
      article: {
        meeting_id: rand(1..5),
        categories: [1, 2, 3, 4].sample(2),
        title: Faker::Book.title,
        body: Faker::Lorem.paragraphs.join,
        author: author_params
      }
    }
  }

  it 'is successful' do
    categories_params = valid_params[:article][:categories].map{ |id| {category_id: id} }
    author_repo = MiniTest::Mock.new.expect(
      :create_with_plain_password, author, [author_params[:name], author_params[:password]]
    )
    article_repo = MiniTest::Mock.new.expect(
      :create, article, [valid_params[:article].merge(author_id: author.id)]
    ).expect(
      :add_categories, nil, [article, categories_params]
    )
    action = Web::Controllers::Article::Create.new(
      author_repo: author_repo,
      article_repo: article_repo
    )
    response = action.call(valid_params)

    response[0].must_equal 302
    author_repo.verify.must_equal true
    article_repo.verify.must_equal true
  end

  it 'is rejected' do
    meeting_repo = MiniTest::Mock.new.expect(:in_time, meetings)
    category_repo = MiniTest::Mock.new.expect(:all, categories)
    action = Web::Controllers::Article::Create.new(
      meeting_repo: meeting_repo,
      category_repo: category_repo
    )
    response = action.call(params)
    
    response[0].must_equal 422
    meeting_repo.verify.must_equal true
    category_repo.verify.must_equal true
  end
end
