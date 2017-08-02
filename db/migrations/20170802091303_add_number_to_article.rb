Hanami::Model.migration do
  change do
    alter_table(:articles) do
      add_column :number, Integer
      add_unique_constraint [:meeting_id, :number]
    end
  end
end
