require_relative '../../../../spec_helper'

describe Admin::Views::Meeting::Article::Index do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/article/index.html.erb') }
  let(:view)      { Admin::Views::Meeting::Article::Index.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
