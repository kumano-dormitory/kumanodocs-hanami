Hanami::Model.migration do
  change do
    create_table :articles do
      primary_key :id

      column :title, String, null: false
      column :body, String, null: false
      column :format, Integer, null: false, default: 0
      column :crypt_password, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
