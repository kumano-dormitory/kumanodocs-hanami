class ArticleCategoryRepository < Hanami::Repository
  associations do
    belongs_to :article
    belongs_to :category
  end
end
