require_relative './form'

module Web::Views::Docs
  class Create
    include Web::View
    include Form
  end
end
