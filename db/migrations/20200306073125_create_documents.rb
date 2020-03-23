Hanami::Model.migration do
  change do
    create_table :documents do
      primary_key :id

      column :title, String, null: false
      column :type, Integer, null: false, default: 0
      column :body, String, null: false
      column :number, Integer

      foreign_key :user_id, :users, type: 'uuid', on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
