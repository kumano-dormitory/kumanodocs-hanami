require 'spec_helper'
require_relative '../../../../../apps/admin/views/meeting/article/create'

describe Admin::Views::Meeting::Article::Create do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/article/create.html.erb') }
  let(:view)      { Admin::Views::Meeting::Article::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    skip 'This is an auto-generated test. Edit it and add your own tests.'

    # Example
    view.foo.must_equal exposures.fetch(:foo)
  end
end