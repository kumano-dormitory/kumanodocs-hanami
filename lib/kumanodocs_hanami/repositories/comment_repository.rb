class CommentRepository < Hanami::Repository
  def find(article_id, block_id)
    comments
      .where(article_id: article_id, block_id: block_id)
      .order(:updated_at)
      .reverse
      .to_a
      .first
  end
end
