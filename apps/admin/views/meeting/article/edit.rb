require_relative './form'

module Admin::Views::Meeting
  module Article
    class Edit
      include Admin::View
      include Form
    end
  end
end
