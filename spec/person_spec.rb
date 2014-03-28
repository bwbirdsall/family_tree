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
