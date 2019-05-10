class MessageRepository < Hanami::Repository
  associations do
    belongs_to :comment
    belongs_to :author
  end

  def by_article(id)
    messages
      .join(comments)
      .where(article_id: id)
      .order(:created_at)
      .to_a
  end
end
