require 'kramdown'

module Web::Views::Docs
  class Show
    include Web::View

    def markdown_to_html(str)
      raw Kramdown::Document.new(str, input: 'GFM', auto_ids: false).to_html
    end
  end
end
