require 'spec_helper'
require_relative '../../../../../apps/web/views/article/lock/new'

describe Web::Views::Article::Lock::New do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/lock/new.html.erb') }
  let(:view)      { Web::Views::Article::Lock::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
