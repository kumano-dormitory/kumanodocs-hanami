class GijirokuRepository < Hanami::Repository
  def find_latest
    gijirokus.order(gijirokus[:created_at].qualified.desc).limit(1).first
  end

  def desc_by_created_at
    gijirokus.order {created_at.desc}
  end
end
