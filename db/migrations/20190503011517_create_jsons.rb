Hanami::Model.migration do
  change do
    create_table :jsons do
      primary_key :id
      column :version, Int
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
