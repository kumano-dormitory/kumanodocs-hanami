require 'spec_helper'
require_relative '../../../../apps/admin/views/number/update'

describe Admin::Views::Number::Update do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/number/update.html.erb') }
  let(:view)      { Admin::Views::Number::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    skip 'This is an auto-generated test. Edit it and add your own tests.'

    # Example
    view.foo.must_equal exposures.fetch(:foo)
  end
end