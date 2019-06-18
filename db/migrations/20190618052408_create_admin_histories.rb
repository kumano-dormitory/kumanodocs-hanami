Hanami::Model.migration do
  change do
    create_table :admin_histories do
      primary_key :id

      column :action, Integer, null: false
      column :json, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
