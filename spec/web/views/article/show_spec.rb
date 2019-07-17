require 'spec_helper'
require_relative '../../../../apps/web/views/article/show'

describe Web::Views::Article::Show do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/show.html.erb') }
  let(:view)      { Web::Views::Article::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
