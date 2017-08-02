Hanami::Model.migration do
  change do
    alter_table :articles do
      add_column :checked, :boolean, null: false, default: false
      add_column :printed, :boolean, null: false, default: false
    end
  end
end
