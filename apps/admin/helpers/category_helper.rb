module Admin
  module Helpers
    module CategoryHelper
      def decorated_categories_name(categories)
        ret = ""
        article.categories.each do |category|
          ret += " 【#{category.name}】"
        end
        ret
      end
    end
  end
end