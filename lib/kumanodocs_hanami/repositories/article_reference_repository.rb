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
end
