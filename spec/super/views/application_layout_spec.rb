require "spec_helper"

describe Super::Views::ApplicationLayout do
  let(:layout)   { Super::Views::ApplicationLayout.new({ format: :html }, "contents") }
  let(:rendered) { layout.render }

  it 'contains application name' do
    rendered.must_include('Super')
  end
end
