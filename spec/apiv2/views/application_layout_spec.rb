require "spec_helper"

describe Apiv2::Views::ApplicationLayout do
  let(:layout)   { Apiv2::Views::ApplicationLayout.new({ format: :html }, "contents") }
  let(:rendered) { layout.render }

  it 'contains application name' do
    rendered.must_include('Apiv2')
  end
end
