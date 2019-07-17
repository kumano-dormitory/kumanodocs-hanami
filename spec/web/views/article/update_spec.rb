require 'spec_helper'
require_relative '../../../../apps/web/views/article/update'

describe Web::Views::Article::Update do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/update.html.erb') }
  let(:view)      { Web::Views::Article::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
