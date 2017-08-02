require_relative './form'

module Web::Views::Article
  class New
    include Web::View
    include Form
  end
end
