module Admin
  module Helpers
    module ArticleHelper
      def article_numbered_title(article)
         "(#{article.number.nil? ? '番号なし' : article.number}) #{article.title}"
      end

      def article_formatted_title(article, checked: false, number: true)
        number_str = if number then "(#{article.number.nil? ? '番号なし' : article.number}) " else '' end
        categories_str = article&.categories&.map{ |category| "#{category.name}"}&.reduce{|ret, str| "#{ret}・#{str}"}
        if categories_str then categories_str = "【#{categories_str}】" end
        checked_str = if checked then (article.checked ? '' : '【追加議案】') else '' end
        "#{number_str}#{checked_str}#{article.title} #{categories_str}"
      end

      def vote_content(article)
        vote_category = article&.categories&.find{ |category| category.name == '採決' }
        if vote_category
          article&.article_categories&.find{ |ac| ac.category_id == vote_category.id }&.extra_content
        else
          ''
        end
      end
    end
  end
end
