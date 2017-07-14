change_type = proc do
  set_column_type :updated_at, 'timestamp with time zone'
  set_column_type :created_at, 'timestamp with time zone'
end
Hanami::Model.migration do
  change do
    [
      :articles,
      :categories,
      :article_categories,
      :meetings,
      :comments,
      :blocks,
      :authors
    ].each do |table_name|
      alter_table table_name, &change_type
    end

    alter_table :meetings do
      set_column_type :deadline, 'timestamp with time zone'
    end
  end
end
