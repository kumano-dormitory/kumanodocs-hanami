class Meeting < Hanami::Entity
  def articles_for_web
    articles_with_nil_number, articles_with_integer_number = articles.partition { |article| article.number.nil? }
    articles_with_integer_number.sort_by! { |article| article.number }
    articles_with_integer_number.concat(articles_with_nil_number)
  end
end
