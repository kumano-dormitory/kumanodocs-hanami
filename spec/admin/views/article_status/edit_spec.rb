require 'spec_helper'
require_relative '../../../../apps/admin/views/article_status/edit'

describe Admin::Views::ArticleStatus::Edit do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/prepare/select.html.erb') }
  let(:view)      { Admin::Views::ArticleStatus::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    skip 'This is an auto-generated test. Edit it and add your own tests.'

    # Example
    view.foo.must_equal exposures.fetch(:foo)
  end
end
