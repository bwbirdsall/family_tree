require 'spec_helper'

describe ParentPair do
  describe '#get_parents' do
    it 'returns both parents in a parent object if both exist.' do
      joan = Person.create(:name => 'Joan')
      robert = Person.create(:name => 'Robert')
      parent = ParentPair.create(:parent1_id => joan.id, :parent2_id => robert.id)
      parent.get_parents.should eq [joan, robert]
    end
    it 'returns one parents in a parent object with only one parent id.' do
      joan = Person.create(:name => 'Joan')
      parent = ParentPair.create(:parent1_id => joan.id)
      parent.get_parents.should eq [joan]
    end
  end

  describe '.make_parents' do
    it 'returns an existing parentpair if one exists for the two parents.' do
      joan = Person.create(:name => 'Joan')
      robert = Person.create(:name => 'Robert')
      parent = ParentPair.create(:parent1_id => joan.id, :parent2_id => robert.id)
      ParentPair.make_parents(joan.id, robert.id).should eq parent
    end
  end

end
