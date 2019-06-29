class AdminHistory < Hanami::Entity
  def formatted_action(action_name_only: false)
    action_number_hash = {
      1 => "ブロック会議の新規作成",
      2 => "ブロック会議の編集",
      3 => "ブロック会議の削除",
      4 => "ブロック会議の議案ダウンロード",
      5 => "議案の新規作成",
      6 => "議案の編集",
      7 => "議案の削除",
      8 => "議案の順番の変更",
      9 => "議案の状態（通常・追加議案）の変更",
      10 => "管理者のログイン",
      11 => "管理者のログアウト",
      12 => "議事録の編集",
      13 => "議事録の削除",
      14 => "表の新規作成",
      15 => "表の編集",
      16 => "表の削除",
      17 => "議事録への返答の新規作成",
      18 => "議事録への返答の編集",
      19 => "議事録への返答の削除"
    }
    ret = action_number_hash.fetch(action, 'その他の操作')
    return ret if action_name_only

    data = JSON.parse(json).fetch("payload", {})
    case action
    when 1 then
      ret = ret + " - ブロック会議の日程[#{data.dig("meeting", "date")}]"
    when 2 then
      ret = ret + " - ブロック会議の日程[#{data.dig("meeting_after", "date")}]（変更後）"
    when 3 then
      ret = ret + " - 削除されたブロック会議の日程[#{data.dig("meeting", "date")}]"
    when 4 then
      ret = ret + " - ダウンロードされたブロック会議の日程[#{data.dig("meeting", "date")}]"
    when 5 then
      ret = ret + " - ブロック会議ID[#{data.dig("article", "meeting_id")}], 議案の題名[#{data.dig("article", "title")}], 文責者[#{data.dig("article", "author", "name")}]"
    when 6 then
      ret = ret + " - ブロック会議[#{data.dig("article_before", "meeting", "date")}](変更前), 議案の題名[#{data.dig("article_after", "title")}](変更後), 文責者[#{data.dig("article_after","author","name")}](変更後)"
    when 7 then
      ret = ret + " - ブロック会議[#{data.dig("article", "meeting", "date")}], 議案の題名[#{data.dig("article", "title")}], 文責者[#{data.dig("article", "author","name")}]"
    when 8 then
      ret = ret + " - ブロック会議ID[#{data.dig("meeting_id")}]"
    when 9 then
      ret = ret + " - ブロック会議ID[#{data.dig("meeting_id")}]"
    when 12 then
      ret = ret + " - ブロック会議日程[#{data.dig("article", "meeting", "date")}], 議案の題名[#{data.dig("article", "title")}], ブロック[#{data.dig("block", "name")}]"
    when 13 then
      ret = ret + " - ブロック会議日程[#{data.dig("article", "meeting", "date")}], 議案の題名[#{data.dig("article", "title")}], ブロック[#{data.dig("block", "name")}]"
    when 14 then
      ret = ret + " - ブロック会議日程[#{data.dig("article", "meeting", "date")}], 議案の題名[#{data.dig("article", "title")}], 表の題名[#{data.dig("table", "caption")}]"
    when 15 then
      ret = ret + " - ブロック会議ID[#{data.dig("article", "meeting_id")}], 議案の題名[#{data.dig("article", "title")}], 表の題名[#{data.dig("table_after", "caption")}](変更後)"
    when 16 then
      ret = ret + " - ブロック会議ID[#{data.dig("article", "meeting_id")}], 議案の題名[#{data.dig("article", "title")}], 表の題名[#{data.dig("table", "caption")}]"
    when 17 then
      ret = ret + " - ブロック会議ID[#{data.dig("article", "meeting_id")}], 議案の題名[#{data.dig("article", "title")}], ブロック[#{data.dig("comment", "block", "name")}]"
    when 18 then
      ret = ret + " - ブロック会議ID[#{data.dig("article", "meeting_id")}], 議案の題名[#{data.dig("article", "title")}], ブロック[#{data.dig("comment", "block", "name")}]"
    when 19 then
      ret = ret + " - ブロック会議ID[#{data.dig("article", "meeting_id")}], 議案の題名[#{data.dig("article", "title")}], ブロック[#{data.dig("comment", "block", "name")}]"
    else
    end
    return ret
  end

  def formatted_created_at
    created_at&.strftime('%Y年%m月%d日 %R')
  end

  def formatted_updated_at
    updated_at&.strftime('%Y年%m月%d日 %R')
  end

  def json_data
    JSON.parse(json).fetch("payload", {})
  end
end
