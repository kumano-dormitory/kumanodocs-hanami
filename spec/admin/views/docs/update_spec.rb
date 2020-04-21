require_relative '../../../spec_helper'

describe Admin::Views::Docs::Update do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/docs/update.html.erb') }
  let(:view)      { Admin::Views::Docs::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
