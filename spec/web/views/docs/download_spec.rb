require_relative '../../../spec_helper'

describe Web::Views::Docs::Download do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/docs/download.html.erb') }
  let(:view)      { Web::Views::Docs::Download.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
