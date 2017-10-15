require 'spec_helper'
require_relative '../../../../apps/admin/controllers/article_status/update'

describe Admin::Controllers::ArticleStatus::Update do
  let(:action) { Admin::Controllers::ArticleStatus::Update.new }
  let(:article_repo) { ArticleRepository.new }
  let(:article) { create(:article) }
  let(:article_param) { {'article_id' => article.id, 'checked' => [true, nil].sample, 'printed' => [true, nil].sample} }
  let(:articles_params) { [article_param] }
  let(:meeting_params) { {articles: articles_params} }
  let(:params) { {meeting: meeting_params, id: article.meeting_id} }

  it 'is successful' do
    response = action.call(params)
    response[0].must_equal 302
  end

  it 'is rejected' do
    response = action.call(id: article.meeting_id)
    response[0].must_equal 422
  end
end
