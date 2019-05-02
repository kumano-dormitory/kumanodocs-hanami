require_relative './form'

module Web::Views::Article
  class Search
    include Web::View
    include Form
  end
end
