require "spec_helper"

describe Super::Views::ApplicationLayout do
  let(:layout)   { Super::Views::ApplicationLayout.new({ format: :html }, "contents") }
  let(:rendered) { layout.render }

  it 'contains application name' do
    _(rendered).must_include('メンテナンス用')
  end
end
