module Admin
  module Helpers
    module CategoryHelper
      def decorated_categories_name(categories)
        categories.map { |category| " 【#{category.name}】 " }.join
      end
    end
  end
end
