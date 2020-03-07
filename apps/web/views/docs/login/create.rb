require_relative './form'

module Web::Views::Docs
  module Login
    class Create
      include Web::View
      include Form
    end
  end
end
