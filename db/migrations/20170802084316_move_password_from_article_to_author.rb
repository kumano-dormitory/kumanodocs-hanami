Hanami::Model.migration do
  change do
    alter_table :articles do
      drop_column :crypt_password
    end
    alter_table :authors do
      add_column :crypt_password, String, null: false
    end
  end
end
