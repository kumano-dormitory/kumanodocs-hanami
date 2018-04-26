require_relative './form'

module Admin::Views::Meeting
  module Article
    class Update
      include Admin::View
      include Form
    end
  end
end
