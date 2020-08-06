require_relative '../../../spec_helper'

describe Web::Views::Article::Top do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/top.html.erb') }
  let(:view)      { Web::Views::Article::Top.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
