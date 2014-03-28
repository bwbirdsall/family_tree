require 'spec_helper'

describe Person do
  it { should validate_presence_of :name }

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it 'returns the parents for a parent object' do
      lacy = Person.create(:name => 'Lacy')
      jack = Person.create(:name => 'Jack')
      steve_parents = Parent.create(:parent1_id => lacy.id, :parent2_id => jack.id)
      steve_parents.get_parents.should eq [lacy, jack]
    end

    it 'returns the parents of a person' do
      steve = Person.create(:name => 'Steve')
      lacy = Person.create(:name => 'Lacy')
      jack = Person.create(:name => 'Jack')
      steve_parents = Parent.create(:parent1_id => lacy.id, :parent2_id => jack.id)
      steve.update(:parent_id => steve_parents.id)
      steve.get_parents.should eq [lacy, jack]
    end

    it 'returns the grandparents of a person' do
      steve = Person.create(:name => 'Steve')
      lacy = Person.create(:name => 'Lacy')
      jack = Person.create(:name => 'Jack')
      ethel = Person.create(:name => 'Ethel')
      ernest = Person.create(:name => 'Ernest')
      oswald = Person.create(:name => 'Oswald')
      maude = Person.create(:name => 'Maude')
      steve_parents = Parent.create(:parent1_id => lacy.id, :parent2_id => jack.id)
      steve.update(:parent_id => steve_parents.id)
      lacy_parents = Parent.create(:parent1_id => ethel.id, :parent2_id => ernest.id)
      lacy.update(:parent_id => lacy_parents.id)
      jack_parents = Parent.create(:parent1_id => maude.id, :parent2_id => oswald.id)
      jack.update(:parent_id => jack_parents.id)
      steve.get_grandparents.should eq [maude, oswald, ethel, ernest]
    end

    it 'returns the children of a person' do
      steve = Person.create(:name => 'Steve')
      lacy = Person.create(:name => 'Lacy')
      steve_parents = Parent.create(:parent1_id => lacy.id)
      steve.update(:parent_id => steve_parents.id)
      lacy.get_children.should eq [steve]
    end

    it 'returns an empty array if a person has no children' do
      steve = Person.create(:name => 'Steve')
      steve.get_children.should eq []
    end

    it 'returns the grandchildren of a person' do
      steve = Person.create(:name => 'Steve')
      lacy = Person.create(:name => 'Lacy')
      ernest = Person.create(:name => 'Ernest')
      steve_parents = Parent.create(:parent1_id => lacy.id)
      steve.update(:parent_id => steve_parents.id)
      lacy_parents = Parent.create(:parent1_id => ernest.id)
      lacy.update(:parent_id => lacy_parents.id)
      ernest.get_grandchildren.should eq [steve]
    end

    it 'returns an empty array if a person has no grandchildren' do
      steve = Person.create(:name => 'Steve')
      steve.get_grandchildren.should eq []
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end
end
