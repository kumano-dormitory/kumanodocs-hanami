Hanami::Model.migration do
  change do
    alter_table :users do
      add_column :authority, Integer, null: false, default: 0
    end
  end
end
