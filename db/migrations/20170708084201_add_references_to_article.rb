Hanami::Model.migration do
  change do
    alter_table :articles do
      add_foreign_key :author_id, :authors, on_delete: :cascade, null: false
      add_foreign_key :meeting_id, :meetings, on_delete: :cascade, null: false
    end
  end
end
