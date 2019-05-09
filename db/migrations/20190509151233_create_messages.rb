Hanami::Model.migration do
  change do
    create_table :messages do
      primary_key :id
      foreign_key :comment_id, :comments, on_delete: :cascade, null: false
      foreign_key :author_id, :authors, on_delete: :cascade, null: false

      column :body, String, null: false
      column :send_by_article_author, :boolean, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
