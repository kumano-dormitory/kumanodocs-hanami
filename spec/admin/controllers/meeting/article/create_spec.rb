require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/create'

describe Admin::Controllers::Meeting::Article::Create do
  let(:action) { Admin::Controllers::Meeting::Article::Create.new }
  let(:article_repo) { ArticleRepository.new }
  let(:category_repo) { CategoryRepository.new }
  let(:meeting_repo) { MeetingRepository.new }
  let(:categories_all) { category_repo.all.map { |category| category.id } }
  let(:meetings_in_time) { meeting_repo.in_time.map { |meeting| meeting.id } }
  let(:meeting_id) { meetings_in_time.sample }
  let(:categories) { categories_all.sample(2) }
  let(:title) { Faker::Book.title }
  let(:author_name) { Faker::Name.name }
  let(:password) { Faker::Internet.password }
  let(:body) { Faker::Lorem.paragraphs.join }
  let(:author_params) { {name: author_name, password: password, password_confirmation: password} }
  let(:article_params) { {meeting_id: meeting_id, categories: categories,
    title: title, author: author_params, body: body} }
  let(:params) { {meeting_id: "#{meeting_id}", article: article_params} }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 302

    article_id = response[1]['Location'].split('/').reverse.first.to_i
    article = article_repo.find_with_relations(article_id)
    article.title.must_equal title
    article.meeting_id.must_equal meeting_id
    article.body.must_equal body
    article.author.name.must_equal author_name
    article.categories.map { |category| category.id }.sort.must_equal categories.sort
  end

  it 'is rejected' do
    params[:article][:title] = nil
    response = action.call(params)
    response[0].must_equal 422
  end
end
