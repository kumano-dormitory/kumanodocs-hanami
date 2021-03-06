require_relative '../../../spec_helper'

describe Web::Views::Comment::Index do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/comment/index.html.erb') }
  let(:view)      { Web::Views::Comment::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
