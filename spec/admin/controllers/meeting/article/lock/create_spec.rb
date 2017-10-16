require 'spec_helper'
require_relative '../../../../../../apps/admin/controllers/meeting/article/lock/create'

describe Admin::Controllers::Meeting::Article::Lock::Create do
  let(:action) { Admin::Controllers::Meeting::Article::Lock::Create.new }
  let(:article_repo) { ArticleRepository.new }
  let(:author_repo) { AuthorRepository.new }
  let(:author) { author_repo.create_with_plain_password(author_name, password) }
  let(:article) { create(:article, author_id: author.id) }
  let(:author_name) { Faker::Name.name }
  let(:password) { Faker::Internet.password }
  let(:author_params) { {password: password} }
  let(:params) { {author: author_params, meeting_id: article.meeting_id, article_id: article.id} }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 302
  end

  it 'is rejected' do
    author_repo.update(author.id, crypt_password: '')
    response = action.call(params)
    response[0].must_equal 401
  end
end
