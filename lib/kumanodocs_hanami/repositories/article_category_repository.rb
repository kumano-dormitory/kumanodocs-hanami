class ArticleCategoryRepository < Hanami::Repository
  def attach_categories(article_id, category_ids)
    datas = category_ids.map { |category_id| { article_id: article_id, category_id: category_id } }
    create(datas)
    # 複数createした場合、返り値が最初の一つ目だけになり混乱を招くので、nilを返すようにしてある
    return nil
  end
end
