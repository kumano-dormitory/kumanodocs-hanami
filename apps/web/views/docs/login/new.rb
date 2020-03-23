require_relative './form'

module Web::Views::Docs
  module Login
    class New
      include Web::View
      include Form
    end
  end
end
