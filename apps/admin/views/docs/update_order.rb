require_relative './form'

module Admin::Views::Docs
  class UpdateOrder
    include Admin::View
    include Form
    layout :docs_order
  end
end
