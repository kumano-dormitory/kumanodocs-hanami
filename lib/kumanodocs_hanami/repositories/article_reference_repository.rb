class ArticleReferenceRepository < Hanami::Repository
  associations do
    belongs_to :articles, as: :article_old, foreign_key: :article_old_id
    belongs_to :articles, as: :article_new, foreign_key: :article_new_id
  end

  def find(id_a, id_b)
    if id_a < id_b
      article_references.where(article_old_id: id_a, article_new_id: id_b).one
    else
      article_references.where(article_old_id: id_b, article_new_id: id_a).one
    end
  end

  def create_refs(article_id, ref_ids, same: false)
    ref_ids&.each do |ref_id|
      unless find(article_id, ref_id)
        if ref_id < article_id
          create(article_old_id: ref_id, article_new_id: article_id, same: same)
        else
          create(article_old_id: article_id, article_new_id: article_id, same: same)
        end
      end
    end
  end

  def find_refs(id)
    ret = article_references
      .where(Sequel.or([[:article_old_id, id],[:article_new_id, id]]))
      .order(article_references[:same].desc,
             article_references[:article_old_id].asc,
             article_references[:article_new_id].asc)
      .to_a
    return ret if ret.empty?

    article_repo = ArticleRepository.new
    article = article_repo.find_with_relations(id, minimum: true)
    ret.map { |ref|
      ArticleReference.new(ref.to_h.merge({
        article_old: (ref.article_old_id == id ? article : article_repo.find_with_relations(ref.article_old_id, minimum: true)),
        article_new: (ref.article_new_id == id ? article : article_repo.find_with_relations(ref.article_new_id, minimum: true))
      }))
    }
  end
end
