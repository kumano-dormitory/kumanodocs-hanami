require_relative '../../../spec_helper'

describe Admin::Views::Meeting::Edit do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/edit.html.erb') }
  let(:view)      { Admin::Views::Meeting::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
