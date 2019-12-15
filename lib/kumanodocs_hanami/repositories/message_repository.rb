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

  def by_meeting(id)
    query = "\
    SELECT messages.id, messages.body, messages.send_by_article_author, articles.id as article_id, articles.number as article_number, comments.id as comment_id \
    FROM messages JOIN comments ON (messages.comment_id = comments.id) JOIN articles ON (comments.article_id = articles.id) \
    WHERE (articles.meeting_id = #{id}) ORDER BY article_number nulls last, article_id, messages.id"
    messages.read(query).map.to_a
  end
end
