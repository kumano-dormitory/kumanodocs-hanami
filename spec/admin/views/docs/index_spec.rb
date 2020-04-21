require_relative '../../../spec_helper'

describe Admin::Views::Docs::Index do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/docs/index.html.erb') }
  let(:view)      { Admin::Views::Docs::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
