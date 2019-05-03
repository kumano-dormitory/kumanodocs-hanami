Hanami::Model.migration do
  change do
    create_table :vote_results do
      primary_key :id
      foreign_key :article_id, :articles, on_delete: :cascade, null: false
      foreign_key :block_id, :blocks, on_delete: :cascade, null: false

      column :agree, Integer, null: false
      column :disagree, Integer, null: false
      column :onhold, Integer, null: false
      column :crypt_password, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
