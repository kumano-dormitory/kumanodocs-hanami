Hanami::Model.migration do
  change do
    alter_table :article_categories do
      set_column_allow_null :extra_content
    end
  end
end
