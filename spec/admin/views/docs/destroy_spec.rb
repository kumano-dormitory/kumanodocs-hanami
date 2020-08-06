require_relative '../../../spec_helper'

describe Admin::Views::Docs::Destroy do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/docs/destroy.html.erb') }
  let(:view)      { Admin::Views::Docs::Destroy.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
