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

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end

    it "updates the spouse's id when it's spouse_id is changed" do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      earl.reload
      earl.spouse_id.should eq steve.id
    end
  end

  describe '#get_parents' do
    it 'returns the parents for a parent object' do
      lacy = Person.create(:name => 'Lacy')
      jack = Person.create(:name => 'Jack')
      steve_parents = ParentPair.create(:parent1_id => lacy.id, :parent2_id => jack.id)
      steve_parents.get_parents.should eq [lacy, jack]
    end

    it 'returns the parents of a person' do
      steve = Person.create(:name => 'Steve')
      lacy = Person.create(:name => 'Lacy')
      jack = Person.create(:name => 'Jack')
      steve_parents = ParentPair.create(:parent1_id => lacy.id, :parent2_id => jack.id)
      steve.update(:parent_id => steve_parents.id)
      steve.get_parents.should eq [lacy, jack]
    end
  end

  describe '#get_grandparents' do
    it 'returns the grandparents of a person' do
      steve = Person.create(:name => 'Steve')
      lacy = Person.create(:name => 'Lacy')
      jack = Person.create(:name => 'Jack')
      ethel = Person.create(:name => 'Ethel')
      ernest = Person.create(:name => 'Ernest')
      oswald = Person.create(:name => 'Oswald')
      maude = Person.create(:name => 'Maude')
      steve_parents = ParentPair.create(:parent1_id => lacy.id, :parent2_id => jack.id)
      steve.update(:parent_id => steve_parents.id)
      lacy_parents = ParentPair.create(:parent1_id => ethel.id, :parent2_id => ernest.id)
      lacy.update(:parent_id => lacy_parents.id)
      jack_parents = ParentPair.create(:parent1_id => maude.id, :parent2_id => oswald.id)
      jack.update(:parent_id => jack_parents.id)
      steve.get_grandparents.should eq [maude, oswald, ethel, ernest]
    end
  end

  describe '#get_children' do
    it 'returns the children of a person' do
      steve = Person.create(:name => 'Steve')
      lacy = Person.create(:name => 'Lacy')
      steve_parents = ParentPair.create(:parent1_id => lacy.id)
      steve.update(:parent_id => steve_parents.id)
      lacy.get_children.should eq [steve]
    end

    it 'returns an empty array if a person has no children' do
      steve = Person.create(:name => 'Steve')
      steve.get_children.should eq []
    end
  end

  describe "#get_siblings" do
    it 'returns the siblings of a person' do
      steve = Person.create(:name => 'Steve')
      joan = Person.create(:name => 'Joan')
      lacy = Person.create(:name => 'Lacy')
      steve_parents = ParentPair.make_parents(lacy.id)
      steve.update(:parent_id => steve_parents.id)
      joan_parents = ParentPair.make_parents(lacy.id)
      joan.update(:parent_id => joan_parents.id)
      steve.get_siblings.should eq [joan]
    end
  end

  describe "#get_aunts_uncles" do
    it "returns the siblings of a person's parents" do
      steve = Person.create(:name => 'Steve')
      joan = Person.create(:name => 'Joan')
      lacy = Person.create(:name => 'Lacy')
      oswaldo = Person.create(:name => 'Oswaldo')
      humberto = Person.create(:name => "Humberto")
      steve_parents = ParentPair.make_parents(lacy.id)
      steve.update(:parent_id => steve_parents.id)
      lacy_parents = ParentPair.make_parents(humberto.id)
      lacy.update(:parent_id => lacy_parents.id)
      joan.update(:parent_id => lacy_parents.id)
      oswaldo.update(:parent_id => lacy_parents.id)
      steve.get_aunts_uncles.should eq [joan, oswaldo]
    end
  end

  describe '#get_grandchildren' do
    it 'returns the grandchildren of a person' do
      steve = Person.create(:name => 'Steve')
      lacy = Person.create(:name => 'Lacy')
      ernest = Person.create(:name => 'Ernest')
      steve_parents = ParentPair.create(:parent1_id => lacy.id)
      steve.update(:parent_id => steve_parents.id)
      lacy_parents = ParentPair.create(:parent1_id => ernest.id)
      lacy.update(:parent_id => lacy_parents.id)
      ernest.get_grandchildren.should eq [steve]
    end

    it 'returns an empty array if a person has no grandchildren' do
      steve = Person.create(:name => 'Steve')
      steve.get_grandchildren.should eq []
    end
  end

  describe '#get_cousins' do
    it 'returns the cousins of a person' do
      steve = Person.create(:name => 'Steve')
      joan = Person.create(:name => 'Joan')
      lacy = Person.create(:name => 'Lacy')
      javier = Person.create(:name => 'Javier')
      oswaldo = Person.create(:name => 'Oswaldo')
      humberto = Person.create(:name => "Humberto")
      steve_parents = ParentPair.make_parents(lacy.id)
      steve.update(:parent_id => steve_parents.id)
      lacy_parents = ParentPair.make_parents(humberto.id)
      lacy.update(:parent_id => lacy_parents.id)
      joan.update(:parent_id => lacy_parents.id)
      oswaldo.update(:parent_id => lacy_parents.id)
      javier_parents = ParentPair.make_parents(oswaldo.id)
      javier.update(:parent_id=> javier_parents.id)
      steve.get_cousins.should eq [javier]
    end
  end
end
