class Parent < ActiveRecord::Base
  validates :parent1_id, :presence => true

  def get_parents
    parents = []
    parents << Person.find(parent1_id)
    if !parent2_id.nil?
      parents << Person.find(parent2_id)
    end
    parents
  end
end
