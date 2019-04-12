class TableRepository < Hanami::Repository
  associations do
    belongs_to :article
  end

  def find_with_relations(id)
    table = aggregate(:article)
            .tables
            .where(id: id)
            .map_to(Table).one
    author = AuthorRepository.new.find(table.article.author_id)
    Table.new(
      table.to_h.merge(article: {author: author}) { |_, oldval, newval|
        oldval.to_h.merge(newval)
      }
    )
  end
end
