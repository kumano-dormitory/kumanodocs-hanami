require 'spec_helper'
require_relative '../../../../apps/web/views/article/show'

describe Web::Views::Article::Show do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/article/show.html.erb') }
  let(:view)      { Web::Views::Article::Show.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    skip 'This is an auto-generated test. Edit it and add your own tests.'

    # Example
    view.foo.must_equal exposures.fetch(:foo)
  end
end
