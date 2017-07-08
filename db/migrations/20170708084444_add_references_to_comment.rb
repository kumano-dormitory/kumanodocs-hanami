Hanami::Model.migration do
  change do
    alter_table :comments do
      add_foreign_key :article_id, :articles, on_delete: :cascade, null: false
      add_foreign_key :block_id, :blocks, on_delete: :cascade, null: false
    end
  end
end
