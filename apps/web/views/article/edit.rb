require_relative './form'

module Web::Views::Article
  class Edit
    include Web::View
    include Form
  end
end
