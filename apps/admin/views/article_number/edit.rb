require_relative './form'

module Admin::Views::ArticleNumber
  class Edit
    include Admin::View
    include Form
    layout :article_order
  end
end
