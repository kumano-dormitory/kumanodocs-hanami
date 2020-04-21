require 'kramdown'

module Admin::Views::Docs
  class Show
    include Admin::View

    def markdown_to_html(str)
      raw Kramdown::Document.new(str, input: 'GFM', auto_ids: false).to_html
    end
  end
end
