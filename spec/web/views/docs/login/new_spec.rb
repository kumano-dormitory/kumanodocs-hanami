require_relative '../../../../spec_helper'

describe Web::Views::Docs::Login::New do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/docs/login/new.html.erb') }
  let(:view)      { Web::Views::Docs::Login::New.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    _(view.format).must_equal exposures.fetch(:format)
  end
end
