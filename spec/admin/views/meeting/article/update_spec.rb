require 'spec_helper'
require_relative '../../../../../apps/admin/views/meeting/article/update'

describe Admin::Views::Meeting::Article::Update do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/article/update.html.erb') }
  let(:view)      { Admin::Views::Meeting::Article::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
