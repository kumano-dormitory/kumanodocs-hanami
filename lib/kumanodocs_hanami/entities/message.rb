class Message < Hanami::Entity
  def formatted_created_at
    created_at&.strftime('%Y年%m月%d日 %R')
  end
end
