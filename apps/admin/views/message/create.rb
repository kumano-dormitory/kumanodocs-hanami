require_relative './form'

module Admin::Views::Message
  class Create
    include Admin::View
    include Form
  end
end
