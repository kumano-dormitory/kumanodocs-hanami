require_relative '../../../spec_helper'

describe Web::Views::Comment::Summary do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/comment/summary.html.erb') }
  let(:view)      { Web::Views::Comment::Summary.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
