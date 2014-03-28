require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'

  loop do
    system('clear')
    puts "What would you like to do?\n\n"
    puts 'Press a to add a family member.'
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see who someone is married to.'
    puts 'Press p to add parents to a person.'
    puts "Press w to see who someone's parents are."
    puts "Press c to see who someone's children are."
    puts "Press g to see who someone's grandparents are."
    puts "Press gc to see who someone's grandchildren are."
    puts 'Press e to exit.'
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'l'
      list
      puts "\nPress enter to return to the main menu."
      gets
    when 'm'
      add_marriage
    when 's'
      show_marriage
    when 'p'
      add_parents
    when 'w'
      list_parents
    when 'c'
      list_children
    when 'g'
      list_grandparents
    when 'gc'
      list_grandchildren
    when 'e'
      exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  if Person.find(name).nil?
    Person.create(:name => name)
    puts name + " was added to the family tree.\n\n"
    puts "Press enter to return to the main menu."
    gets
  else
    puts "#{name} already exists in our table. If this is a Jr or III type situation, include that in the name."
    puts "Press enter to return to the main menu."
    gets
  end
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
  puts "\nPress enter to return to the main menu."
  gets
end

def add_parents
  list
  puts "Enter the number of the person to add parents to:"
  person = Person.find(gets.chomp)
  if person.parent_id.nil?
    puts "Enter the number of a parent:"
    parent1 = Person.find(gets.chomp)
    puts "Enter the number of the second parent: (Enter nothing if only one parent is known)"
    parent2 = Person.find(gets.chomp)
    parents = Parent.create(:parent1_id => parent1.id)
    if parent2 != nil
      parents.update(:parent2_id => parent2.id)
      puts "#{parent1.name} and #{parent2.name} added as #{person.name}'s parents."
    else
      puts "#{parent1.name} added as #{person.name}'s parent."
    end
    person.update(:parent_id => parents.id)
    puts "\nPress enter to return to the main menu."
    gets
  else
    puts "#{person.name} already has parents.  Thanks for trying!"
    puts "\nPress enter to return to the main menu."
    gets
  end
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + "."
  puts "\nPress enter to return to the main menu."
  gets
end

def list_parents
  list
  puts "Enter the number of the relative and I'll show you who their parent(s) are."
  person = Person.find(gets.chomp)
  parents = person.get_parents
  if !parents.nil?
    parents.each { |parent| puts "#{parent.name} is #{person.name}'s parent." }
  else
    puts "#{person.name} has no parents in our system. Please enter them if you would like to see them here."
  end
  puts "\nPress enter to return to the main menu."
  gets
end

def list_children
  list
  puts "Enter the number of the relative and I'll show you who their children are."
  person = Person.find(gets.chomp)
  children = person.get_children
  if children != []
    children.each { |child| puts "#{child.name} is #{person.name}'s child."}
  else
    puts "#{person.name} has no children in our system. Please enter them if you would like to see them."
  end
  puts "\nPress enter to return to the main menu."
  gets
end

def list_grandparents
  list
  puts "Enter the number of the relative and I'll show you who their grandparent(s) are."
  person = Person.find(gets.chomp)
  grand_parents = person.get_grandparents
  if grand_parents != []
    grand_parents.each { |grand_parent| puts "#{grand_parent.name} is #{person.name}'s grandparent." }
  else
    puts "#{person.name} has no grandparents in our system. Please enter then if you would like to see them."
  end
  puts "\nPress enter to return to the main menu."
  gets
end

def list_grandchildren
  list
  puts "Enter the number of the relative and I'll show you who their grandchildren are."
  person = Person.find(gets.chomp)
  grandchildren = person.get_grandchildren
  if grandchildren == []
    puts "#{person.name} has no grandchildren in our system. If they should, enter those people to make them viewable."
  else
    grandchildren.each { |grandchild| puts "#{grandchild.name} is #{person.name}'s grandchild."}
  end
  puts "\nPress enter to return to the main menu."
  gets
end



menu
