class GijirokuRepository < Hanami::Repository
  def find_latest
    gijirokus.order(gijirokus[:created_at].qualified.desc).limit(1).first
  end
end
