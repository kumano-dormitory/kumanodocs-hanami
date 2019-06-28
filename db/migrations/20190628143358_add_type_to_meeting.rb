Hanami::Model.migration do
  change do
    alter_table :meetings do
      add_column :type, Integer, null: false, default: 0
    end
  end
end
