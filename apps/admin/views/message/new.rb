require_relative './form'

module Admin::Views::Message
  class New
    include Admin::View
    include Form
  end
end
