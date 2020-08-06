require_relative '../../../spec_helper'

describe Web::Views::Gijiroku::Show do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/gijiroku/show.html.erb') }
  let(:view)      { Web::Views::Gijiroku::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
