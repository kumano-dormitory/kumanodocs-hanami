require 'spec_helper'
require_relative '../../../../apps/admin/views/article_number/update'

describe Admin::Views::ArticleNumber::Update do
  let(:meeting) { Meeting.new(id: rand(1..50), date: Date.today, articles: [article]) }
  let(:article) { Article.new(id: rand(1..100), title: Faker::Lorem.word, author: author, created_at: Time.now) }
  let(:author) { Author.new(id: rand(1..100), name: Faker::Name.name) }
  let(:exposures) { {meeting: meeting, for_download: [true, false].sample, params: {}} }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/article_number/update.html.erb') }
  let(:view)      { Admin::Views::ArticleNumber::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes meeting & for_download' do
    _(view.meeting).must_equal exposures.fetch(:meeting)
    _(view.for_download).must_equal exposures.fetch(:for_download)
  end

  it 'displays edit article order page' do
    _(rendered).must_match '議案の並び替え'
    _(rendered).must_match article.title
  end
end
