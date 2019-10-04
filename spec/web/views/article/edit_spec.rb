require 'spec_helper'
require_relative '../../../../apps/web/views/article/edit'

describe Web::Views::Article::Edit do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/edit.html.erb') }
  let(:view)      { Web::Views::Article::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
