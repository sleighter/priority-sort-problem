#event allocator

class Group
  class << self
    attr_accessor :all
  end
  self.all = []

  def initialize(group_name, num_people, choice_one, choice_2, choice_3)
    self.name = group_name
    self.num_people = num_people.to_i
    self.choice_one = choice_one
    self.choice_two = choice_two
    self.choice_three = choice_three
	end

  # attr_accessor automatically provides getters and setters for all these
  attr_accessor :choice_one, :choice_two, :choice_three, :name, :num_people

	def output_attr #this function is being used for testing
		puts group_name
		puts num_people
		puts choice_one
		puts choice_two
		puts choice_three
	end
end

class Event #complete
  class << self
    attr_accessor :all
  end
  self.all = []

  attr_accessor :date, :capacity, :group_attend_list

  def initialize(event_date, event_capacity)
    self.date = event_date                # I use self to distinguish instance vars from params
		self.capacity = event_capacity.to_i
		self.group_attend_list = []
	end

	def add_to_attend_list(group)
		group_attend_list << group #uncertain why I'm getting an undefined method error
	end

	def group_attend_list_delete(group)
	  group_attend_list.delete(group)
	end

  def attendance
    group_attend_list.inject(0) {|acc, group_list| acc += group_list.num_people}
  end
end

def main
  input_groups
	#test_input_groups
	input_events
	assign_first_choice

	over_capacity_events, under_capacity_events = find_over_capacity_under_capacity
	write_to_file if over_capacity_events.length == 0
	reassignment_second(over_capacity_events, under_capacity_events)

  reassignment_switch1 = true
	while over_capacity_events.length > 0 && reassignment_switch1 == true
    reassignment_switch1 = reassignment_second(over_capacity_events, under_capacity_events)
    over_capacity_events, under_capacity_events = find_over_capacity_under_capacity
  end

	reassignment_switch2 = true
	while over_capacity_events.length > 0 && reassignment_switch2 == true
    reassignment_switch2 = reassignment_third(over_capacity_events, under_capacity_events)
	  over_capacity_events, under_capacity_events = find_over_capacity_under_capacity
  end

	write_error_to_file(over_capacity_events) if over_capacity_events.length > 0
	write_to_file
end

#test functions these will be used to see where the error in the code
#arose from

def test_input_groups
	Group.all.each do |group|
	  group.output_attr
	end
end




def input_groups #might need some work but mostly done
  group_info = IO.readlines("group_input.txt", "r") # no need for absolute paths if data is in same directory
	group_info.each do |line|                     #python code not sure if this breaks down lines from files
		indv_group_info = line.split(",")			      #this command should break each line into individual words
		new_group_obj = Group.new(
      indv_group_info[0],
      indv_group_info[1],
      indv_group_info[2],
      indv_group_info[3],
      indv_group_info[4])
		Group.all << new_group_obj		              #not sure if this will work
	end
end

def input_events
  event_info = IO.readlines("event_input.txt", "r")
	event_info.each do |line|
	  indv_event_info = line.split(",")		#not sure if this is a command in ruby
		new_event_obj = Event.new indv_event_info[0], indv_event_info[1]
		Event.all << new_event_obj
	end
end

def assign_first_choice                      #assigns all groups to their first choice's event list
  Group.all.each do |group|                  #was class variable now is global
    Event.all.each do |event|                #was class variable now is global
	    if group.choice_one == event.date			 #changed to method
		    event.add_to_attend_list(group)      #changed to method
	    end
    end
	end
end

def test_assign_first_choice
  Event.all.each do |event|
    puts event.find_group_attend_list
	end
end
#partially debugged this function
def find_over_capacity_under_capacity #returns 2 arrays
  over_capacity_events = []
  under_capacity_events = []

  Event.all.each do |event| #was class variable now is global
		if event.attendance > event.capacity
		  over_capacity_events << event
    else
      under_capacity_events << event
		end
	end
	return over_capacity_events, under_capacity_events
end

def reassignment_second(over_capacity_events, under_capacity_events) #didn't run any test conditions
  over_capacity_events.each do |over_capacity_event|
    event.group_attend_list.each do |group|
      under_capacity_events.each do |under_capacity_event|
  	    if under_capacity_event.date == group.choice_two
  		    under_capacity_event.add_to_attend_list(group)
  			  event.group_attend_list_delete(group)
  		  end
      end
		end
  end
end

def reassignment_third(over_capacity_events, under_capacity_events) #no test conditions run read over
  over_capacity_events.each do |over_capacity_event|
	  event.group_attend_list.each do |group|
      under_capacity_events.each do |under_capacity_event|
			  choice_three = group.choice_three
		    if under_capacity_event.date == choice_three
			    under_capacity_event.add_to_attend_list(group)
				  over_capacity_event.group_attend_list_delete (group)
        end
		  end
	  end
  end
end

def capacity_met
  over_capacity_events, under_capacity_events = find_over_capacity_under_capacity #no need for parens if no params
	over_capacity_events.length == 0 # ruby automatically returns the value of the last statement, no 'return' needed here
end

def write_to_file #seems to be debugged file was written to with appropriate results given sample
  output_file = File.open("output.txt", "w")
	Event.all.each do |event| #was class variable now is global
    line_to_write = []
    line_to_write << event.date

    event.group_attend_list.each do |group|
			line_to_write << group.name
		end

    line_to_write << "\n"
		output_file.syswrite(line_to_write.join(" "))
	end
end

def write_error_to_file(over_capacity_events) #not debugged yet
  output_file = File.open("output.txt","w")
  over_capacity_events.each do |event|
    output_file.syswrite(event)
	  output_file.syswrite("is over capacity")
	end
end
