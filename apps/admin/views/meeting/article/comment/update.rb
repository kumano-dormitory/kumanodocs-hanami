require_relative './form'

module Admin::Views::Meeting
  module Article
    module Comment
      class Update
        include Admin::View
        include Form
      end
    end
  end
end
