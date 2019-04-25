require_relative './form'

module Admin::Views::ArticleNumber
  class Update
    include Admin::View
    include Form
    layout :article_order
  end
end
