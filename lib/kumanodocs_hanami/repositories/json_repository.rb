class JsonRepository < Hanami::Repository
  def find_meeting(id)
    query = "select id, date, deadline from meetings where id = #{id}"
    jsons.read(query).map.first
  end

  def meetings_list(limit: 20, offset: offset)
    query = "select id, date, deadline from meetings order by date desc, id desc limit #{limit} offset #{offset}"
    jsons.read(query).map.to_a
  end

  def articles_by_meeting(id)
    query = "\
    select articles.id, title, body, format, articles.created_at, articles.updated_at, \
           authors.name as author_name, checked, printed, number, \
           string_agg(categories.name, '・') as category_name \
    from articles join meetings on articles.meeting_id = meetings.id \
                  join authors on articles.author_id = authors.id \
                  join article_categories on articles.id = article_categories.article_id \
                  join categories on article_categories.category_id = categories.id \
    where meetings.id = #{id} \
    group by articles.id, authors.id \
    order by articles.number asc nulls last, articles.id desc"
    jsons.read(query).map.to_a
  end

  def article_details(id)
    article_query = "\
    select articles.id, title, body, format, articles.created_at, articles.updated_at, \
           authors.name as author_name, checked, printed, number, \
           meeting_id, date as meeting_date, deadline as meeting_deadline \
    from articles join meetings on articles.meeting_id = meetings.id \
                  join authors on articles.author_id = authors.id \
    where articles.id = #{id}"
    category_query = "\
    select ac.id, ac.extra_content, ac.created_at, ac.updated_at, ac.category_id, \
           ca.name as category_name, ca.require_content \
    from article_categories as ac join categories as ca on ac.category_id = ca.id \
    where ac.article_id = #{id}"
    comment_query = "\
    select comments.id, comments.body, comments.created_at, comments.updated_at, \
           comments.block_id, blocks.name as block_name \
    from comments join blocks on comments.block_id = blocks.id where comments.article_id = #{id}"
    table_query = "select id, caption, csv, created_at, updated_at from tables where tables.article_id = #{id}"
    vote_result_query = "\
    select vote_results.id, vote_results.agree, vote_results.disagree, vote_results.onhold, \
           vote_results.block_id, blocks.name as block_name \
    from vote_results  join blocks on vote_results.block_id = blocks.id \
    where vote_results.article_id = #{id}"
    article = jsons.read(article_query).map.first
    return nil unless article
    categories = jsons.read(category_query).map.to_a
    comments = jsons.read(comment_query).map.to_a
    vote_results = jsons.read(vote_result_query).map.to_a
    tables = jsons.read(table_query).map.to_a
    article.merge({
      categories: categories,
      comments: comments,
      vote_results: vote_results,
      tables: tables
    })
  end

  def search_articles(keywords: [''], limit: 25, offset: 0)
    keywords_str = keywords.map { |keyword|
      key = jsons.dataset.escape_like(keyword).gsub(/'/, "''")
      "((title ILIKE '%#{key}%' ESCAPE '\\') OR (body ILIKE '%#{key}%' ESCAPE '\\') OR (authors.name ILIKE '%#{key}%' ESCAPE '\\'))"
    }.join(' AND ')
    search_query = "\
    SELECT articles.id, title, body, format, articles.created_at, articles.updated_at,\
           checked, printed, number, authors.name as author_name, \
           meetings.date as meeting_date, meetings.deadline as meeting_deadline, \
           string_agg(categories.name, '・') as category_name \
    from articles join authors on articles.author_id = authors.id \
                  join meetings on articles.meeting_id = meetings.id \
                  join article_categories on articles.id = article_categories.article_id \
                  join categories on article_categories.category_id = categories.id \
    where (#{keywords_str}) \
    group by articles.id, authors.id, meetings.id \
    order by meetings.date desc, articles.number asc, articles.id desc \
    limit #{limit} offset #{offset}"
    jsons.read(search_query).map.to_a
  end

  def comments_by_meeting(id)
    query = "\
    SELECT * FROM ( \
      (SELECT blocks.id as block_id, blocks.name as block_name, articles.title, articles.id as article_id, articles.number as article_number, comments.body , null as agree, null as disagree, null as onhold FROM comments JOIN articles ON (comments.article_id = articles.id) JOIN blocks ON (comments.block_id = blocks.id) WHERE (articles.meeting_id = #{id})) \
      UNION \
      (SELECT blocks.id as block_id, blocks.name as block_name, articles.title, articles.id as article_id, articles.number as article_number, null as body, vote_results.agree, vote_results.disagree, vote_results.onhold FROM vote_results JOIN articles ON (vote_results.article_id = articles.id) JOIN blocks ON (vote_results.block_id = blocks.id) WHERE (articles.meeting_id = #{id})) \
    ) AS tt ORDER BY article_number nulls last, article_id, block_id, body nulls last"
    jsons.read(query).map.to_a
  end
end
