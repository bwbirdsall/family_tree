class Person < ActiveRecord::Base
  # has_many :people through: :ex_spouses
  has_one :parent
  validates :name, :presence => true

  after_save :make_marriage_reciprocal

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

  def get_parents
    if parent_id != nil
      parent = Parent.find(parent_id)
      parent.get_parents
    else
      nil
    end
  end

  def get_grandparents
    grandparents = []
    parents = self.get_parents
    if !parents.nil?
      parents.each do |parent|
        if parent.get_parents != nil
          grandparents = parent.get_parents + grandparents
        end
      end
    end
    grandparents
  end

  def get_children
    children = []
    pairings = Parent.where(:parent1_id => self.id)
    pairings = pairings + Parent.where(:parent2_id => self.id)
    if pairings != nil
      pairings.each do |pair|
        children = Person.where(:parent_id => pair.id) + children
      end
    end
    children
  end

  def get_grandchildren
    grandchildren = []
    children = self.get_children
    if children != []
      children.each { |child| grandchildren = grandchildren + child.get_children }
    end
    grandchildren
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
