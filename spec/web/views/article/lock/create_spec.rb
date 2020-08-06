require 'spec_helper'
require_relative '../../../../../apps/web/views/article/lock/create'

describe Web::Views::Article::Lock::Create do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/lock/create.html.erb') }
  let(:view)      { Web::Views::Article::Lock::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
