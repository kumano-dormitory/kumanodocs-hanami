Hanami::Model.migration do
  change do
    create_table :categories do
      primary_key :id

      column :name, String, null: false
      column :require_content, Bool, null: false, default: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
