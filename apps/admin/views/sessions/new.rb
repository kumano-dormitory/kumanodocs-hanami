require_relative './form'

module Admin::Views::Sessions
  class New
    include Admin::View
    include Form
    layout :login
  end
end
