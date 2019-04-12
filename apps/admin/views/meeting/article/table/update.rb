require_relative './form'

module Admin::Views::Meeting
  module Article
    module Table
      class Update
        include Admin::View
        include Form
      end
    end
  end
end
