require_relative './form'

module Admin::Views::Meeting
  module Article
    module Table
      class New
        include Admin::View
        include Form
      end
    end
  end
end
