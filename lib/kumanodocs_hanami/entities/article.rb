class Article < Hanami::Entity
  def formatted_created_at
    created_at&.strftime('%Y年%m月%d日 %R')
  end

  def formatted_updated_at
    updated_at&.strftime('%Y年%m月%d日 %R')
  end
end
