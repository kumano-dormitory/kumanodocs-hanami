require 'spec_helper'
require_relative '../../../../apps/admin/views/article_status/update'

describe Admin::Views::ArticleStatus::Update do
  let(:meeting) { Meeting.new(id: rand(1..50), date: Date.today, articles: [article]) }
  let(:article) { Article.new(id: rand(1..100), title: Faker::Lorem.word, checked: checked, created_at: Time.now) }
  let(:checked) { [true, false].sample }
  let(:exposures) { {meeting: meeting, params: {}} }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/article_status/update.html.erb') }
  let(:view)      { Admin::Views::ArticleStatus::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes meeting' do
    _(view.meeting).must_equal exposures.fetch(:meeting)
  end

  it 'displays edit article order page' do
    _(rendered).must_match '資料委員会が確認済みか'
    _(rendered).must_match article.title
    _(rendered).must_match '保存'
  end
end
