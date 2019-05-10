class CommentRepository < Hanami::Repository
  def find(article_id, block_id)
    comments
      .where(article_id: article_id, block_id: block_id)
      .order(:updated_at)
      .reverse
      .to_a
      .first
  end

  def find_by_id(id)
    comments.where(id: id).one
  end

  def create_list(datas)
    transaction do
      datas.each do |data|
        create(data)
      end
    end
  end

  def update_list(datas)
    transaction do
      datas.each do |data|
        update(data[:id], data)
      end
    end
  end

  def by_meeting(meeting_id)
    query = "\
    SELECT * FROM ( \
      (SELECT blocks.id as block_id, blocks.name as block_name, articles.title, articles.id as article_id, articles.number as article_number, comments.body , null as agree, null as disagree, null as onhold FROM comments JOIN articles ON (comments.article_id = articles.id) JOIN blocks ON (comments.block_id = blocks.id) WHERE (articles.meeting_id = #{meeting_id})) \
      UNION \
      (SELECT blocks.id as block_id, blocks.name as block_name, articles.title, articles.id as article_id, articles.number as article_number, null as body, vote_results.agree, vote_results.disagree, vote_results.onhold FROM vote_results JOIN articles ON (vote_results.article_id = articles.id) JOIN blocks ON (vote_results.block_id = blocks.id) WHERE (articles.meeting_id = #{meeting_id})) \
    ) AS tt ORDER BY article_number nulls last, article_id, block_id, body nulls last"
    comments.read(query).map.to_a
  end
end
