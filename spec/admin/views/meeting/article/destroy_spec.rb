require 'spec_helper'
require_relative '../../../../../apps/admin/views/meeting/article/destroy'

describe Admin::Views::Meeting::Article::Destroy do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/article/destroy.html.erb') }
  let(:view)      { Admin::Views::Meeting::Article::Destroy.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
