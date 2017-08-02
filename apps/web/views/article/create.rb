require_relative './form'

module Web::Views::Article
  class Create
    include Web::View
    include Web::Views::Article::Form
  end
end
