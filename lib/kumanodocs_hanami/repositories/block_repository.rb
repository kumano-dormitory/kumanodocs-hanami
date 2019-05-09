class BlockRepository < Hanami::Repository
  def by_meeting_with_comment_vote_count(meeting_id)
    query = "SELECT tt.id, tt.name, count(tt.comment_id) as comment_count, count(tt.vote_result_id) as vote_result_count \
    FROM (
     (SELECT blocks.id, blocks.name, comments.id as comment_id, null as vote_result_id, \
             CASE WHEN articles.meeting_id IS NULL THEN #{meeting_id} ELSE articles.meeting_id END \
      FROM blocks LEFT OUTER JOIN comments ON (blocks.id = comments.block_id) \
                  LEFT OUTER JOIN articles ON (comments.article_id = articles.id) )
    UNION
     (SELECT blocks.id, blocks.name, null as comment_id, vote_results.id as vote_result_id, \
             CASE WHEN articles.meeting_id IS NULL THEN #{meeting_id} ELSE articles.meeting_id END \
      FROM blocks LEFT OUTER JOIN vote_results ON (blocks.id = vote_results.block_id) \
                  LEFT OUTER JOIN articles ON (vote_results.article_id = articles.id) )
    ) as tt \
    WHERE (tt.meeting_id = #{meeting_id})
    GROUP BY tt.id, tt.name
    ORDER BY tt.id"
    blocks.read(query).map.to_a
  end
end
