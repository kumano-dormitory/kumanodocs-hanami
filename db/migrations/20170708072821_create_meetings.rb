Hanami::Model.migration do
  change do
    create_table :meetings do
      primary_key :id

      column :data, Date, null: false
      column :deadline, DateTime, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
