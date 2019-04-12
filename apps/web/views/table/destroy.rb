require_relative './form'

module Web::Views::Table
  class Destroy
    include Web::View
    include Form
  end
end
