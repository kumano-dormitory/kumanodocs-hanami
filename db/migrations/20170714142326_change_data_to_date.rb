Hanami::Model.migration do
  change do
    alter_table :meetings do
      rename_column :data, :date
    end
  end
end
