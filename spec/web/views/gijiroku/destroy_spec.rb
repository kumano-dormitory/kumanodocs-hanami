require_relative '../../../spec_helper'

describe Web::Views::Gijiroku::Destroy do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/gijiroku/destroy.html.erb') }
  let(:view)      { Web::Views::Gijiroku::Destroy.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
