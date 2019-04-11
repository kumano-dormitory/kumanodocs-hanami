require 'csv'

class Table < Hanami::Entity
  def data
    CSV.parse(csv)
  end
end
