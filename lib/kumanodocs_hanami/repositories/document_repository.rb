class DocumentRepository < Hanami::Repository
  associations do
    belongs_to :user
  end

  def order_by_number
    aggregate(:user)
      .documents
      .order(documents[:number].asc(nulls: :last), documents[:id].asc)
  end

  def find_with_relations(id)
    aggregate(:user)
      .documents
      .where(id: id)
      .map_to(Document)
      .one
  end

  def by_user(user_id)
    documents
      .where(user_id: user_id)
      .order(documents[:number].asc(nulls: :last), documents[:id].asc)
  end

  def update_number(docs_number)
    transaction do
      documents.update(number: nil) # 全ての資料の番号をリセット
      docs_number.each do |attr|
        update(attr['document_id'], number: attr['number'])
      end
    end
  end
end
