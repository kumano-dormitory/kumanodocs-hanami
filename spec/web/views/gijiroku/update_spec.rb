require_relative '../../../spec_helper'

describe Web::Views::Gijiroku::Update do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/gijiroku/update.html.erb') }
  let(:view)      { Web::Views::Gijiroku::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
