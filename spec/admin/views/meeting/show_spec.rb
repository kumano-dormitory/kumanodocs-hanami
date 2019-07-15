require 'spec_helper'
require_relative '../../../../apps/admin/views/meeting/show'

describe Admin::Views::Meeting::Show do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/show.html.erb') }
  let(:view)      { Admin::Views::Meeting::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
