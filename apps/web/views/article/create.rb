require_relative './form'

module Web::Views::Article
  class Create
    include Web::View
    include Form
  end
end
