require 'csv'

class Table < Hanami::Entity
  def data
    CSV.parse(csv, col_sep: "\t")
  end
end
