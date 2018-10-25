Hanami::Model.migration do
  change do
    add_column :comments, :crypt_password, String, null: false
  end
end
