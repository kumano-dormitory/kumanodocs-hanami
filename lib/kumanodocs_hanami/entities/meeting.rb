class Meeting < Hanami::Entity
  def articles_for_web
    articles_with_nil_number, articles_with_integer_number = articles.partition { |article| article.number.nil? }
    articles_with_integer_number.sort_by! { |article| article.number }
    articles_with_integer_number.concat(articles_with_nil_number)
  end

  def formatted_date
    date&.strftime('%Y年%m月%d日')
  end

  def formatted_deadline
    deadline&.strftime('%Y年%m月%d日 %R')
  end
end
