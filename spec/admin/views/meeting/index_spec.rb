require 'spec_helper'
require_relative '../../../../apps/admin/views/meeting/index'

describe Admin::Views::Meeting::Index do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/index.html.erb') }
  let(:view)      { Admin::Views::Meeting::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
