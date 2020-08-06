require_relative '../../../spec_helper'

describe Admin::Views::Docs::Edit do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/docs/edit.html.erb') }
  let(:view)      { Admin::Views::Docs::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
