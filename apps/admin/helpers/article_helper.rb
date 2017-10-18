module Admin
  module Helpers
    module ArticleHelper
      def article_numbered_title(article)
         "(#{article.number.nil? ? '番号なし' : article.number}) #{article.title}"
      end
    end
  end
end
