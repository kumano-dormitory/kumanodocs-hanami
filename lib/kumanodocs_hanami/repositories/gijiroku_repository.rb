class GijirokuRepository < Hanami::Repository
  def find_latest
    gijirokus.order { created_at.desc }.limit(1).first
  end
end
