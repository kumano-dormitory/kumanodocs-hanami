Hanami::Model.migration do
  change do
    create_table :article_categories do
      primary_key :id

      column :extra_content, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
