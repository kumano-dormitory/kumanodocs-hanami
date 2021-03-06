require_relative '../../../spec_helper'

describe Admin::Views::Docs::Order do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/docs/order.html.erb') }
  let(:view)      { Admin::Views::Docs::Order.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
