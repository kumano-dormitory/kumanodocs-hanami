require_relative '../../../../spec_helper'

describe Admin::Views::Meeting::Article::Show do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/article/show.html.erb') }
  let(:view)      { Admin::Views::Meeting::Article::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
