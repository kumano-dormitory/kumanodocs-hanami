require 'spec_helper'
require_relative '../../../../apps/web/controllers/article/edit'

describe Web::Controllers::Article::Edit do
  let(:article) { create(:article) }
  let(:meeting) { Meeting.new(id: article.meeting_id) }
  let(:article_repo) { ArticleRepository.new }
  let(:author_repo) { AuthorRepository.new }
  let(:categories) { [Category.new(id: rand(1..5))] }
  let(:params) { {id: article.id} }

  it 'is successful' do
    meeting_repo = MiniTest::Mock.new.expect(:in_time, [meeting])
    category_repo = MiniTest::Mock.new.expect(:all, categories)
    action = Web::Controllers::Article::Edit.new(
      article_repo: article_repo,
      meeting_repo: meeting_repo,
      category_repo: category_repo
    )
    lock_key = author_repo.lock(article.author_id, '')
    params.merge!("HTTP_COOKIE"=>"article_lock_key=#{lock_key}")

    response = action.call(params)

    response[0].must_equal 200
    meeting_repo.verify.must_equal true
    category_repo.verify.must_equal true
  end

  it 'is rejected' do
    action = Web::Controllers::Article::Edit.new(article_repo: article_repo)
    response = action.call(params)
    # ロックを取るページへリダイレクトすることを確認
    response[0].must_equal 302
  end
end
