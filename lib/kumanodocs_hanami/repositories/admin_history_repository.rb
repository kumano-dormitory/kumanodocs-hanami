class AdminHistoryRepository < Hanami::Repository
  def add(action, json)
    action_number_hash = {
      "meeting_create": 1,
      "meeting_update": 2,
      "meeting_destroy": 3,
      "meeting_download": 4,
      "article_create": 5,
      "article_update": 6,
      "article_destroy": 7,
      "article_number_update": 8,
      "article_status_update": 9,
      "sessions_create": 10,
      "sessions_destroy": 11,
      "comment_update": 12,
      "comment_destroy": 13,
      "table_create": 14,
      "table_update": 15,
      "table_destroy": 16,
      "message_create": 17,
      "message_update": 18,
      "message_destroy": 19
    }
    action_number = action_number_hash.fetch(action, 0)
    create(action: action_number, json: json)
  end
end
