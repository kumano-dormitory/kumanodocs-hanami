require_relative '../../../spec_helper'

describe Admin::Views::Docs::UpdateOrder do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/docs/update_order.html.erb') }
  let(:view)      { Admin::Views::Docs::UpdateOrder.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
