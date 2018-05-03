require_relative '../../../spec_helper'

describe Web::Views::Meeting::Index do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/meeting/index.html.erb') }
  let(:view)      { Web::Views::Meeting::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
