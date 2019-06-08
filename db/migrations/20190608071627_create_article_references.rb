Hanami::Model.migration do
  change do
    create_table :article_references do
      foreign_key :article_old_id, :articles, on_delete: :cascade, null: false
      foreign_key :article_new_id, :articles, on_delete: :cascade, null: false
      primary_key [:article_old_id, :article_new_id], name: :article_references_pk

      column :same, :boolean, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      constraint(:article_id_constraint) { article_old_id < article_new_id }
    end
  end
end
