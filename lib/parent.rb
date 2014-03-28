class ParentPair < ActiveRecord::Base
  validates :parent1_id, :presence => true

  def get_parents
    parents = []
    parents << Person.find(parent1_id)
    if !parent2_id.nil?
      parents << Person.find(parent2_id)
    end
    parents
  end

  def self.make_parents(parent1_id, parent2_id=nil)
    parent = self.find_by(:parent1_id => parent1_id, :parent2_id => parent2_id)
    if parent.nil?
      parent = self.find_by(:parent1_id => parent2_id, :parent2_id => parent1_id)
    end
    if parent.nil?
      parent = self.create(:parent1_id => parent1_id, :parent2_id => parent2_id)
    end
    parent
  end
end
