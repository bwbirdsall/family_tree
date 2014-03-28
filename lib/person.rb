class Person < ActiveRecord::Base
  # has_many :people through: :ex_spouses
  has_one :parent_pair
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
      parent = ParentPair.find(parent_id)
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
    pairings = ParentPair.where(:parent1_id => self.id)
    pairings = pairings + ParentPair.where(:parent2_id => self.id)
    if pairings != nil
      pairings.each do |pair|
        children = Person.where(:parent_id => pair.id) + children
      end
    end
    children
  end

  def get_siblings
    siblings = []
    if !self.parent_id.nil?
      sibling_query = Person.where(:parent_id => self.parent_id)
      sibling_query.each do |sibling|
        siblings << sibling
        if !sibling.spouse_id.nil?
          siblings << Person.find(sibling.spouse_id)
        end
      end
      siblings = siblings - [self]
      if !self.spouse_id.nil?
        siblings = siblings - [Person.find(self.spouse_id)]
      end
    end
    siblings
  end

  def get_aunts_uncles
    aunts_uncles = []
    parents = self.get_parents
    parents.each { |parent| aunts_uncles = aunts_uncles + parent.get_siblings }
    aunts_uncles
  end

  def get_cousins
    cousins = []
    aunts_uncles = self.get_aunts_uncles
    if aunts_uncles != []
      aunts_uncles.each { |aunt_uncle| cousins = cousins + aunt_uncle.get_children }
    end
    cousins = cousins.uniq
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
