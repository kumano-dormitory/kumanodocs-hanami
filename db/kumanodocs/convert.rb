# load csv files
require 'csv'

# id,title,author,text,vote_content,hashed_password,issue_order,meeting_id,created_at,updated_at
csv_issues = CSV.read(File.dirname(__FILE__) + '/issues.csv', headers: true)

# id,issue_id,issuetype_id
csv_issue_type = CSV.read(File.dirname(__FILE__) + '/issue_type.csv', headers: true)

#id,meeting_date
csv_meetings = CSV.read(File.dirname(__FILE__) + '/meetings.csv', headers: true)

# id,text,hashed_password,block_id,issue_id
csv_notes = CSV.read(File.dirname(__FILE__) + '/notes.csv', headers: true)

# id,caption,csv_text,table_order,issue_id
csv_tables = CSV.read(File.dirname(__FILE__) + '/tables.csv', headers: true)

# id,name
csv_blocks = CSV.read(File.dirname(__FILE__) + '/blocks.csv', headers: true)

# id,name
csv_categories = CSV.read(File.dirname(__FILE__) + '/categories.csv', headers: true)

meeting_id_map = Hash.new()
meeting_repo = MeetingRepository.new
csv_meetings.each do |meeting|
  date = Date.parse(meeting["meeting_date"])
  meeting_ret = meeting_repo.create(
    date: date,
    deadline: (Time.new(date.year, date.month, date.day, 20, 0, 0, "+09:00") - (60 * 60 * 24 * 2))
  )
  meeting_id_map.store(meeting["id"], meeting_ret.id)
end

category_id_map = Hash.new()
category_repo = CategoryRepository.new
csv_categories.each do |category|
  category_ret = category_repo.create(name: category["name"], require_content: category["require_content"])
  category_id_map.store(category["id"], category_ret.id)
end
block_id_map = Hash.new()
block_repo = BlockRepository.new
csv_blocks.each do |block|
  block_ret = block_repo.create(name: block["name"])
  block_id_map.store(block["id"], block_ret.id)
end

article_repo = ArticleRepository.new
article_category_repo = ArticleCategoryRepository.new
author_repo = AuthorRepository.new
comment_repo = CommentRepository.new
table_repo = TableRepository.new

key_array = Array.new(240) { Hash.new() }

csv_issues.each do |issue|
  if key_array.at(issue["meeting_id"].to_i).has_key?(issue['issue_order'].to_i)
    number = nil
  else
    key_array.at(issue["meeting_id"].to_i).store(issue["issue_order"].to_i, true)
    number = (issue["issue_order"].to_i < 0 ? nil : issue["issue_order"].to_i)
  end
  meeting_id = meeting_id_map.fetch(issue["meeting_id"], 1)

  author = author_repo.create(name: issue["author"], crypt_password: issue["hashed_password"])
  article = article_repo.create(
    title: issue["title"],
    body: issue["text"],
    number: number,
    format: 0,
    checked: true,
    printed: true,
    meeting_id: meeting_id,
    author_id: author.id,
    created_at: issue["created_at"],
    updated_at: issue["updated_at"]
  )
  issue_types = csv_issue_type.find_all{ |issue_type| issue_type["issue_id"] == issue["id"] }
  issue_types.each do |issue_type|
    category_id = category_id_map.fetch(issue_type["issuetype_id"], 1)
    article_category_repo.create(
      extra_content: (issue_type["issuetype_id"] == "3" ? issue["vote_content"] : nil),
      article_id: article.id,
      category_id: category_id,
      created_at: issue["created_at"],
      updated_at: issue["updated_at"]
    )
  end

  notes = csv_notes.find_all{ |note| note["issue_id"] == issue["id"] }
  notes.each do |note|
    block_id = block_id_map.fetch(note["block_id"], 1)
    comment_repo.create(
      body: note["text"],
      crypt_password: note["hashed_password"],
      article_id: article.id,
      block_id: block_id,
      created_at: issue["created_at"],
      updated_at: issue["updated_at"]
    )
  end

  tables = csv_tables.find_all{ |table| table["issue_id"] == issue["id"] }
  tables.each do |table|
    table_repo.create(
      caption: table["caption"],
      csv: table["csv_text"],
      article_id: article.id,
      created_at: issue["created_at"],
      updated_at: issue["updated_at"]
    )
  end
end
