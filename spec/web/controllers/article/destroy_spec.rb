require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/destroy'

describe Web::Controllers::Article::Destroy do
  let(:action) { Web::Controllers::Article::Destroy.new }
  let(:article_repo) { ArticleRepository.new }

  it 'is successful' do
    article = create(:article)
    pre_article_count = article_repo.all.count
    response = action.call({id: article.id})
    response[0].must_equal 302
    article_repo.all.count.must_equal pre_article_count - 1
  end
end
