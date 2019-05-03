class JsonRepository < Hanami::Repository
  def find_meeting(id)
    query = "select id, date, deadline from meetings where id = #{id}"
    jsons.read(query).map.first
  end

  def meetings_list(limit: 20)
    query = "select id, date, deadline from meetings order by date desc, id desc limit #{limit}"
    jsons.read(query).map.to_a
  end

  def articles_by_meeting(id)
    query = "\
    select articles.id, title, body, format, articles.created_at, articles.updated_at, \
    authors.name as author_name, checked, printed, number \
    from articles join meetings on articles.meeting_id = meetings.id \
                  join authors on articles.author_id = authors.id \
    where meetings.id = #{id} order by articles.number asc nulls last, articles.id desc"
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
    article = jsons.read(article_query).map.first
    return nil unless article
    categories = jsons.read(category_query).map.to_a
    comments = jsons.read(comment_query).map.to_a
    tables = jsons.read(table_query).map.to_a
    article.merge({
      categories: categories,
      comments: comments,
      tables: tables
    })
  end

  def search_articles(keywords: [''], limit: 25, offset: 0)
    keywords_str = keywords.map { |keyword|
      key = jsons.dataset.escape_like(keyword)
      "((title ILIKE '%#{key}%' ESCAPE '\\') OR (body ILIKE '%#{key}%' ESCAPE '\\') OR (authors.name ILIKE '%#{key}%' ESCAPE '\\'))"
    }.join(' AND ')
    search_query = "\
    SELECT articles.id, title, body, format, articles.created_at, articles.updated_at,\
           checked, printed, number, authors.name as author_name, \
           meetings.date as meeting_date, meetings.deadline as meeting_deadline \
    from articles join authors on articles.author_id = authors.id \
                  join meetings on articles.meeting_id = meetings.id \
    where (#{keywords_str}) \
    order by meetings.date desc, articles.number asc, articles.id desc \
    limit #{limit} offset #{offset}"
    jsons.read(search_query).map.to_a
  end
end
