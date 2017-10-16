require 'spec_helper'
require_relative '../../../../../apps/admin/controllers/meeting/article/update'

describe Admin::Controllers::Meeting::Article::Update do
  let(:action) { Admin::Controllers::Meeting::Article::Update.new }
  let(:author_repo) { AuthorRepository.new }
  let(:category_repo) { CategoryRepository.new }
  let(:article) { create(:article) }
  let(:title) { Faker::Book.title }
  let(:author_params) { {name: Faker::Name.name} }
  let(:body) { Faker::Lorem.paragraphs.join }
  let(:categories_params) { category_repo.all.sample(2).map { |category| category.id } }
  let(:article_params) { { meeting_id: article.meeting_id,
                           categories: categories_params,
                           title: title,
                           author: author_params,
                           body: body,
                           get_lock: false } }
  let(:params) { {article: article_params, id: article.id} }

  it 'is successful' do
    lock_key = author_repo.lock(article.author_id, '')
    params.merge!("HTTP_COOKIE" => "article_lock_key=#{lock_key}")
    response = action.call(params)
    response[0].must_equal 302
  end

  it 'get lock' do
    author_repo.lock(article.author_id, '')
    params[:article][:get_lock] = true
    response = action.call(params)
    response[0].must_equal 302
  end

  it 'is required confirmation' do
    author_repo.lock(article.author_id, '')
    response = action.call(params)
    response[0].must_equal 200
  end

  it 'is rejected' do
    params[:article][:title] = nil
    response = action.call(params)
    response[0].must_equal 422
  end
end
