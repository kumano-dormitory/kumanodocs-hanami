require 'spec_helper'
require_relative '../../../../apps/admin/views/article_number/edit'

describe Admin::Views::ArticleNumber::Edit do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/prepare/arrange.html.erb') }
  let(:view)      { Admin::Views::ArticleNumber::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    skip 'This is an auto-generated test. Edit it and add your own tests.'

    # Example
    view.foo.must_equal exposures.fetch(:foo)
  end
end
