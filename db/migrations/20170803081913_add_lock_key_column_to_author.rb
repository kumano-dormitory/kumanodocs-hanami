Hanami::Model.migration do
  change do
    add_column :authors, :lock_key, String, null: true
  end
end
