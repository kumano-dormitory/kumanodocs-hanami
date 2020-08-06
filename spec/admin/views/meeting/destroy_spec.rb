require_relative '../../../spec_helper'

describe Admin::Views::Meeting::Destroy do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/destroy.html.erb') }
  let(:view)      { Admin::Views::Meeting::Destroy.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
