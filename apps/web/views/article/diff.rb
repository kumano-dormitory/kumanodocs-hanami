require_relative './form'

module Web::Views::Article
  class Diff
    include Web::View
    include Form
    layout :diff
  end
end
