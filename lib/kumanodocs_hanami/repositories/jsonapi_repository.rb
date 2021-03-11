class JsonapiRepository < Hanami::Repository
  def find_meeting(id)
    query = "select id, type, date, deadline from meetings where id = #{id}"
    jsonapis.read(query).map.first
  end

  def meetings_list(limit: 20, offset: 0)
    query = "select id, type, date, deadline from meetings order by date desc, id desc limit #{limit} offset #{offset}"
    jsonapis.read(query).map.to_a
  end

  def find_past_meeting(meeting_id)
    query = "select id, type, date, deadline from meetings \
    where date < (select date from meetings where id = #{meeting_id}) \
    order by date desc limit 1"
    jsonapis.read(query).map.first
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
    order by articles.number asc nulls last, articles.id asc"
    jsonapis.read(query).map.to_a
  end

  def article_details(id)
    article_query = "\
    select articles.id, title, body, format, articles.created_at, articles.updated_at, \
           authors.name as author_name, checked, printed, number, \
           string_agg(categories.name, '・') as category_name, \
           meeting_id, meetings.date as meeting_date, meetings.deadline as meeting_deadline, meetings.type as meeting_type \
    from articles join meetings on articles.meeting_id = meetings.id \
                  join authors on articles.author_id = authors.id \
                  join article_categories on articles.id = article_categories.article_id \
                  join categories on article_categories.category_id = categories.id \
    where articles.id = #{id} \
    group by articles.id, meetings.id, authors.id"
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
    message_query = "\
    select messages.id, messages.body, messages.comment_id, messages.send_by_article_author, \
           blocks.name as block_name \
    from messages join comments on (messages.comment_id = comments.id) \
                  join blocks on (comments.block_id = blocks.id) \
    where comments.article_id = #{id}"
    article_reference_query ="\
    select ref_articles.reference_id, ref_articles.same, articles.title, \
           meetings.date, authors.name as author_name, string_agg(categories.name, '・') as category_name from (
      (select ar.article_new_id as reference_id, ar.same from article_references as ar where ar.article_old_id = #{id}) \
        UNION \
      (select ar.article_old_id as reference_id, ar.same from article_references as ar where ar.article_new_id = #{id}) \
    ) as ref_articles join articles on ref_articles.reference_id = articles.id \
                      join meetings on articles.meeting_id = meetings.id \
                      join authors on articles.author_id = authors.id \
                      join article_categories on articles.id = article_categories.article_id \
                      join categories on article_categories.category_id = categories.id \
    group by ref_articles.reference_id, ref_articles.same, articles.id, authors.id, meetings.id \
    order by ref_articles.reference_id desc"
    article = jsonapis.read(article_query).map.first
    return nil unless article
    categories = jsonapis.read(category_query).map.to_a
    comments = jsonapis.read(comment_query).map.to_a
    vote_results = jsonapis.read(vote_result_query).map.to_a
    tables = jsonapis.read(table_query).map.to_a
    messages = jsonapis.read(message_query).map.to_a
    article_references = jsonapis.read(article_reference_query).map.to_a
    article.merge({
      categories: categories,
      comments: comments,
      vote_results: vote_results,
      tables: tables,
      messages: messages,
      article_references: article_references
    })
  end

  def search_articles(keywords: [''], limit: 25, offset: 0)
    keywords_str = keywords.map { |keyword|
      key = jsonapis.dataset.escape_like(keyword).gsub(/'/, "''")
      "((title ILIKE '%#{key}%' ESCAPE '\\') OR (body ILIKE '%#{key}%' ESCAPE '\\') OR (authors.name ILIKE '%#{key}%' ESCAPE '\\'))"
    }.join(' AND ')
    search_query = "\
    SELECT articles.id, title, body, format, articles.created_at, articles.updated_at,\
           checked, printed, number, authors.name as author_name, meetings.id as meeting_id, meetings.type as meeting_type, \
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
    jsonapis.read(search_query).map.to_a
  end

  def search_articles_count(keywords: [''])
    keywords_str = keywords.map { |keyword|
      key = jsonapis.dataset.escape_like(keyword).gsub(/'/, "''")
      "((title ILIKE '%#{key}%' ESCAPE '\\') OR (body ILIKE '%#{key}%' ESCAPE '\\') OR (authors.name ILIKE '%#{key}%' ESCAPE '\\'))"
    }.join(' AND ')
    search_query = "\
    SELECT articles.id, title, body, format, articles.created_at, articles.updated_at,\
           checked, printed, number, authors.name as author_name \
    from articles join authors on articles.author_id = authors.id \
    where (#{keywords_str})"
    jsonapis.read(search_query).map.to_a.length
  end

  def detail_search_articles(title_keywords: [''], author_keywords: [''], body_keywords: [''],
                             category_ids: [], limit: 25, offset: 0)
    title_query = title_keywords.map { |keyword|
      key = jsonapis.dataset.escape_like(keyword).gsub(/'/, "''")
      "(title ILIKE '%#{key}%' ESCAPE '\\')"
    }.join(' AND ')
    author_query = author_keywords.map { |keyword|
      key = jsonapis.dataset.escape_like(keyword).gsub(/'/, "''")
      "(authors.name ILIKE '%#{key}%' ESCAPE '\\')"
    }.join(' AND ')
    body_query = body_keywords.map { |keyword|
      key = jsonapis.dataset.escape_like(keyword).gsub(/'/, "''")
      "(body ILIKE '%#{key}%' ESCAPE '\\')"
    }.join(' AND ')

    category_query = category_ids.map { |id|
      "(categories.id = #{id})"
    }.join(' OR ')
    if !category_query.empty?
      category_query = "AND (#{category_query})"
    end
    search_query = "\
    SELECT articles.id, title, body, format, articles.created_at, articles.updated_at,\
           checked, printed, number, authors.name as author_name, meetings.id as meeting_id, meetings.type as meeting_type, \
           meetings.date as meeting_date, meetings.deadline as meeting_deadline, \
           string_agg(categories.name, '・') as category_name \
    from articles join authors on articles.author_id = authors.id \
                  join meetings on articles.meeting_id = meetings.id \
                  join article_categories on articles.id = article_categories.article_id \
                  join categories on article_categories.category_id = categories.id \
    where (#{title_query} AND #{author_query} AND #{body_query} #{category_query}) \
    group by articles.id, authors.id, meetings.id \
    order by meetings.date desc, articles.number asc, articles.id desc \
    limit #{limit} offset #{offset}"
    jsonapis.read(search_query).map.to_a
  end

  def detail_search_articles_count(title_keywords: [''], author_keywords: [''], body_keywords: [''], category_ids: [])
    title_query = title_keywords.map { |keyword|
    key = jsonapis.dataset.escape_like(keyword).gsub(/'/, "''")
    "(title ILIKE '%#{key}%' ESCAPE '\\')"
    }.join(' AND ')
    author_query = author_keywords.map { |keyword|
    key = jsonapis.dataset.escape_like(keyword).gsub(/'/, "''")
    "(authors.name ILIKE '%#{key}%' ESCAPE '\\')"
    }.join(' AND ')
    body_query = body_keywords.map { |keyword|
    key = jsonapis.dataset.escape_like(keyword).gsub(/'/, "''")
    "(body ILIKE '%#{key}%' ESCAPE '\\')"
    }.join(' AND ')

    category_query = category_ids.map { |id|
    "(categories.id = #{id})"
    }.join(' OR ')
    if !category_query.empty?
    category_query = "AND (#{category_query})"
    end
    search_query = "\
    SELECT articles.id, title, body, format, articles.created_at, articles.updated_at,\
           checked, printed, number, authors.name as author_name,
           string_agg(categories.name, '・') as category_name \
    from articles join authors on articles.author_id = authors.id \
                  join meetings on articles.meeting_id = meetings.id \
                  join article_categories on articles.id = article_categories.article_id \
                  join categories on article_categories.category_id = categories.id \
    where (#{title_query} AND #{author_query} AND #{body_query} #{category_query}) \
    group by articles.id, authors.id, meetings.id"
    jsonapis.read(search_query).map.to_a.length
  end

  def comments_by_meeting(id)
    query = "\
    SELECT block_id, block_name, title, article_id, article_number, max(id) as id, string_agg(body, '') as body, \
           sum(agree) as agree, sum(disagree) as disagree, sum(onhold) as onhold \
    FROM ( \
      (SELECT blocks.id as block_id, blocks.name as block_name, articles.title, \
              articles.id as article_id, articles.number as article_number, comments.id as id, comments.body, \
              null as agree, null as disagree, null as onhold \
        FROM comments JOIN articles ON (comments.article_id = articles.id) \
                      JOIN blocks ON (comments.block_id = blocks.id) \
        WHERE (articles.meeting_id = #{id})) \
      UNION \
      (SELECT blocks.id as block_id, blocks.name as block_name, articles.title, \
              articles.id as article_id, articles.number as article_number, null as id, null as body, \
              vote_results.agree, vote_results.disagree, vote_results.onhold \
        FROM vote_results JOIN articles ON (vote_results.article_id = articles.id) \
                          JOIN blocks ON (vote_results.block_id = blocks.id) \
        WHERE (articles.meeting_id = #{id})) \
    ) AS tt \
    GROUP BY block_id, block_name, title, article_id, article_number \
    ORDER BY article_number nulls last, article_id, block_id, body nulls last"
    jsonapis.read(query).map.to_a
  end

  def messages_by_meeting(id)
    query = "\
    SELECT messages.id, messages.body, messages.send_by_article_author, \
           articles.id as article_id, articles.number as article_number, comments.id as comment_id \
    FROM messages JOIN comments ON (messages.comment_id = comments.id) \
                  JOIN articles ON (comments.article_id = articles.id) \
    WHERE (articles.meeting_id = #{id}) \
    ORDER BY article_number nulls last, article_id, messages.id"
    jsonapis.read(query).map.to_a
  end

  def gijirokus_list
    query = "SELECT id, description, created_at, updated_at FROM gijirokus ORDER BY created_at"
    jsonapis.read(query).map.to_a
  end

  def find_gijiroku(id)
    query = "SELECT id, description, body, created_at, updated_at FROM gijirokus WHERE id = #{id}"
    jsonapis.read(query).map.first
  end

  def latest_gijiroku
    query = "SELECT id, description, body FROM gijirokus ORDER BY created_at DESC LIMIT 1"
    jsonapis.read(query).map.to_a.fetch(0, {id: 0, description: '', body: ''})
  end
end
