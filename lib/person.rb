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
    parent = Parent.find(parent_id)
    parent.get_parents
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
