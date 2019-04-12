Hanami::Model.migration do
  change do
    alter_table :tables do
      add_foreign_key :article_id, :articles, on_delete: :cascade, null: false
    end
  end
end
