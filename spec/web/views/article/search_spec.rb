require_relative '../../../spec_helper'

describe Web::Views::Article::Search do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/search.html.erb') }
  let(:view)      { Web::Views::Article::Search.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
