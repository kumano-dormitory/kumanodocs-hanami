require 'spec_helper'

describe Admin::Views::Meeting::Article::Comment::Edit do
  let(:exposures) { Hash[format: :html] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/meeting/article/comment/edit.html.erb') }
  let(:view)      { Admin::Views::Meeting::Article::Comment::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    view.format.must_equal exposures.fetch(:format)
  end
end
