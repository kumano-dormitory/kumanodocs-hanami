Hanami::Model.migration do
  change do
    create_table :comments do
      primary_key :id

      column :body, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
