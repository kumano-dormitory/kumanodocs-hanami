require_relative '../../../spec_helper'

describe Web::Views::Docs::Edit do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/docs/edit.html.erb') }
  let(:view)      { Web::Views::Docs::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
