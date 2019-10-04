require_relative '../../../spec_helper'

describe Web::Views::Article::Diff do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/diff.html.erb') }
  let(:view)      { Web::Views::Article::Diff.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
