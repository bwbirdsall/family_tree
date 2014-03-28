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
    puts "Press b to see who someone's siblings are."
    puts "Press c to see who someone's children are."
    puts "Press g to see who someone's grandparents are."
    puts "Press gc to see who someone's grandchildren are."
    puts "Press u to see who someone's aunts and uncles are."
    puts "Press cu to see who someone's cousins are."
    puts "Press e to end a marriage."
    puts "Press x to list a person's ex-spouses."
    puts "Enter 'exit' to exit."
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'l'
      list_relatives
    when 'm'
      add_marriage
    when 's'
      show_marriage
    when 'p'
      add_parents
    when 'w'
      list_parents
    when 'b'
      list_siblings
    when 'c'
      list_children
    when 'g'
      list_grandparents
    when 'gc'
      list_grandchildren
    when 'u'
      list_aunts_uncles
    when 'cu'
      list_cousins
    when 'e'
      end_marriage
    when 'x'
      list_exes
    when 'exit'
      exit
    end
  end
end

def add_person
  system('clear')
  puts "***** Add Person *****\n"
  puts 'What is the name of the family member?'
  name = gets.chomp
  if Person.find_by(:name => name).nil?
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
  system('clear')
  puts "***** Add Marriage *****\n"
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
  system('clear')
  puts "***** Add Parents *****\n"
  list
  puts "Enter the number of the person to add parents to:"
  person = Person.find(gets.chomp)
  if person.parent_id.nil?
    puts "Enter the number of a parent:"
    parent1 = Person.find(gets.chomp)
    puts "Enter the number of the second parent: (Enter nothing if only one parent is known)"
    parent2 = Person.find(gets.chomp)
    if parent2.nil?
      parents = ParentPair.make_parents(parent1.id, nil)
      puts "#{parent1.name} added as #{person.name}'s parent."
    else
      parents = ParentPair.make_parents(parent1.id, parent2.id)
      puts "#{parent1.name} and #{parent2.name} added as #{person.name}'s parents."
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

def list_relatives
  system('clear')
  puts "***** Relatives *****\n\n"
  list
  puts "\nPress enter to return to the main menu."
  gets
end

def show_marriage
  system('clear')
  puts "***** Show Marraige *****\n"
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  if !person.spouse.nil?
    spouse = Person.find(person.spouse_id)
    puts person.name + " is married to " + spouse.name + "."
  else
    puts person.name + " is not currently married."
  end
  puts "\nPress enter to return to the main menu."
  gets
end

def list_parents
  system('clear')
  puts "***** List Parents *****\n"
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
  system('clear')
  puts "***** List Children *****\n"
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

def list_siblings
  system('clear')
  puts "***** List Siblings *****\n"
  list
  puts "Enter the number of the relative to see who their siblings are."
  person = Person.find(gets.chomp)
  siblings = person.get_siblings
  if siblings != []
    siblings.each { |sibling| puts "#{sibling.name} is #{person.name}'s sibling."}
  else
    puts "#{person.name} has no children in our system. Please enter them if you would like to see them."
  end
  puts "\nPress enter to return to the main menu."
  gets
end

def list_grandparents
  system('clear')
  puts "***** List Grandparents *****\n"
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
  system('clear')
  puts "***** List Grandchildren *****\n"
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

def list_aunts_uncles
  system('clear')
  puts "***** List Aunts and Uncles *****\n"
  list
  puts "Enter the number of the relative and I'll show you who their aunts and uncles are."
  person = Person.find(gets.chomp)
  aunts_uncles = person.get_aunts_uncles
  if aunts_uncles == []
    puts "\n#{person.name} has no aunts or uncles in our system. If they should, enter those people to make them viewable."
  else
    puts ""
    aunts_uncles.each { |aunt_uncle| puts "#{aunt_uncle.name} is #{person.name}'s aunt/uncle." }
  end
  puts "\nPress enter to return to the main menu."
  gets
end

def list_cousins
  system('clear')
  puts "***** List Cousins *****\n"
  list
  puts "Enter the number of the relative and I'll show you who their cousins are."
  person = Person.find(gets.chomp)
  cousins = person.get_cousins
  if cousins == []
    puts "\n#{person.name} has no cousins in our system. If they should, enter those people to make them viewable."
  else
    puts ""
    cousins.each { |cousin| puts "#{cousin.name} is #{person.name}'s cousin." }
  end
  puts "\nPress enter to return to the main menu."
  gets
end

def end_marriage
  system('clear')
  puts "******* End Marriage ******\n\n"
  list
  puts "Enter which person's marriage has come to a tragic end, whether or not it is for the best."
  person = Person.find(gets.chomp)
  spouse = person.spouse
  person.end_marriage
  puts "\nThe marriage of #{person.name} and #{spouse.name} has been recoded as over."
  puts "Press enter to return to the main menu."
  gets
end

def list_exes
  system('clear')
  puts "******* List Ex-Spouses ******\n\n"
  list
  puts "Enter which person's ex-spouses you would like to see."
  person = Person.find(gets.chomp)
  puts
  person.exspouses.each { |ex| puts person.name + " was once married to " + Person.find(ex.ex_spouse_id).name }
  puts "\nPress enter to return to the main menu."
  gets
end

menu
