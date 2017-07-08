Hanami::Model.migration do
  change do
    create_table :comments do
      primary_key :id

      foreign_key :article_id, :articles, on_delete: :cascade, null: false
      foreign_key :block_id, :blocks, on_delete: :cascade, null: false
      column :body, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
