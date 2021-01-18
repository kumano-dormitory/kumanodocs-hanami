# ====
# 一般向けページのヘルパー関数モジュール
# ====
# 一般向けページの全てのテンプレートファイル内で利用することのできるヘルパー関数
# テンプレートファイル内に記述するには複雑な処理や頻繁に使用する処理をヘルパー関数としてまとめている

require 'kramdown'

module Web
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
        vote_category = article&.categories&.find{ |category| category.name == '採決' || category.name == '採決予定' }
        if vote_category
          h article&.article_categories&.find{ |ac| ac.category_id == vote_category.id }&.extra_content
        else
          ''
        end
      end

      def after_6pm(article, meeting)
        date = meeting.date
        meeting_date_6pm = Time.new(date.year, date.mon, date.day, 18,0,0,"+09:00")
        article.created_at > meeting_date_6pm
      end

      def markdown_to_html(str)
        raw Kramdown::Document.new(str, input: 'GFM', auto_ids: false).to_html
      end

      def url_parse(str)
        str.gsub(/(http:|https:)[^\(\)[:space:]（）、。]*/) { |url|
          "<a href='#{hu url}'>#{url}</a>"
        }
      end
    end
  end
end
