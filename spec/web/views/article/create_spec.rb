require 'spec_helper'
require_relative '../../../../apps/web/views/article/create'

describe Web::Views::Article::Create do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/create.html.erb') }
  let(:view)      { Web::Views::Article::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
