require_relative './form'

module Admin::Views::Message
  class Destroy
    include Admin::View
    include Form
  end
end
