class CommentRepository < Hanami::Repository
  def find(article_id, block_id)
    comments
      .where(article_id: article_id, block_id: block_id)
      .order(:updated_at)
      .reverse
      .to_a
      .first
  end

  def create_list(datas)
    transaction do
      datas.each do |data|
        create(data)
      end
    end
  end

  def update_list(datas)
    transaction do
      datas.each do |data|
        update(data[:id], data)
      end
    end
  end
end
