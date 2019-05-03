Hanami::Model.migration do
  change do
    alter_table(:comments) do
      add_unique_constraint [:article_id, :block_id]
    end
    alter_table(:vote_results) do
      add_unique_constraint [:article_id, :block_id]
    end
  end
end
