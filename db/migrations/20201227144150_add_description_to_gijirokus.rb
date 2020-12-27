Hanami::Model.migration do
  change do
    alter_table :gijirokus do
      add_column :description, String, default: ""
    end
  end
end
