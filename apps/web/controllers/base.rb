module Web
  module BaseController
    def self.included(action)
      action.class_eval do
        expose :navigation
      end
    end

    def navigation
      @navigation = {}
    end
  end
end
