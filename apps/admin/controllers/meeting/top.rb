module Admin
  module Controllers
    module Meeting
      class Top
        include Admin::Action

        def call(params)
        end

        def navigation
          @navigation = {root: true}
        end
      end
    end
  end
end
