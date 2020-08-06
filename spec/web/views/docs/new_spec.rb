require_relative '../../../spec_helper'

describe Web::Views::Docs::New do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/docs/new.html.erb') }
  let(:view)      { Web::Views::Docs::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
