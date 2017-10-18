module Admin
  module Helpers
    module CategoryHelper
      def decorated_category_name(category)
        " 【#{category.name}】 "
      end
    end
  end
end
