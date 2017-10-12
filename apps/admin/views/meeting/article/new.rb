require_relative './form'

module Admin::Views::Meeting
  module Article
    class New
      include Admin::View
      include Form
    end
  end
end
