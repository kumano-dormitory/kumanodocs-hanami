require_relative './form'

module Admin
  module Views
    module Sessions
      class Create
        include Admin::View
        include Form
        layout :login
      end
    end
  end
end
