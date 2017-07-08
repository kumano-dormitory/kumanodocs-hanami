Hanami::Model.migration do
  change do
    create_table :article_categories do
      primary_key :id

      foreign_key :article_id, :articles, on_delete: :cascade, null: false
      foreign_key :category_id, :categories, on_delete: :cascade, null: false
      column :extra_content, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
