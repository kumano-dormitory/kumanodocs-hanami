Hanami::Model.migration do
  change do
    alter_table :article_categories do
      add_foreign_key :article_id, :articles, on_delete: :cascade, null: false
      add_foreign_key :category_id, :categories, on_delete: :cascade, null: false
    end
  end
end
