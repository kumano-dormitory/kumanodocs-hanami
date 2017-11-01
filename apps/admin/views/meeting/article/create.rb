require_relative './form'

module Admin::Views::Meeting
  module Article
    class Create
      include Admin::View
      include Form
    end
  end
end
