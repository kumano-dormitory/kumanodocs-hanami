require_relative './form'

module Web::Views::Article
  class Destroy
    include Web::View
    include Form
  end
end
