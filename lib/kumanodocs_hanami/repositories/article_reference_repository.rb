class ArticleReferenceRepository < Hanami::Repository
  associations do
    belongs_to :articles, as: :article_old, foreign_key: :article_old_id
    belongs_to :articles, as: :article_new, foreign_key: :article_new_id
  end
end
