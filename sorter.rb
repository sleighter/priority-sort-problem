#event allocator

$group_list = [] #couldn't figure out how to initialize a class variable
class Group #complete?
    @@group_list = []
    def initialize(group_name, num_people, choice_one, choice_two, choice_three)
	    @group_name = group_name
	    @num_people = num_people.to_i
        @choice_one = choice_one
        @choice_two = choice_two
        @choice_three = choice_three
	end
		
	def find_choice_one    #using these to access group attributes unsure if this is necessary
		return @choice_one #it seems unwielding almost certain there is a simpler way to access
	end                    #instance variables   
	def find_choice_two
		return @choice_two
	end
	def find_choice_three
		return @choice_three
	end
	def find_group_name
	    return @group_name
	end
	
	def find_num_people
		return @num_people
	end
	
	def output_attr #this function is being used for testing
		puts @group_name
		puts @num_people
		puts @choice_one
		puts @choice_two
		puts @choice_three
	end
end

$event_list = [] #couldn't figure out how to initialize a class variable
class Event #complete
    @@event_list = []
    def initialize(event_date, event_capacity)
	    @event_date = event_date
		@event_capacity = event_capacity.to_i
		@group_attend_list = Array.new
	end
	
	def add_to_attend_list(group)
		@group_attend_list << group #uncertain why I'm getting an undefined method error
	end
	
	def group_attend_list_delete(group)
	    @group_attend_list.delete(group)
	end
	
	def find_event_date
		return @event_date
	end
	
	def find_event_capacity
		return @event_capacity
	end
	
	def find_group_attend_list
		return @group_attend_list
	end
end

def main
    input_groups
	#test_input_groups
	input_events
	assign_first_choice
	over_capacity_events, under_capacity_events = find_over_capacity_under_capacity #does this work in Ruby?
	if over_capacity_events.length == 0
	    write_to_file
	else
	    pass #does this work in ruby
	end
	reassignment_second(over_capacity_events, under_capacity_events)
	reassignment_switch1 = true
	while over_capacity_events.length > 0 and reassignment_switch1 == true
	    reassignemtn_switch1 = reassignment_second(over_capacity_events, under_capacity_events)
        over_capacity_events, under_capacity_events = find_over_capacity_under_capacity 
    end
	reassignment_switch2 = true
	while over_capacity_events.length > 0 and reassignment_switch2 == true
	    reassignment_switch2 = reassignment_third(over_capacity_events, under_capacity_events)
		over_capacity_events, under_capacity_events = find_over_capacity_under_capacity
    end		
	if over_capacity_events.length > 0
		write_error_to_file(over_capacity_events)
	end
	write_to_file
end

#test functions these will be used to see where the error in the code
#arose from

def test_input_groups
	for group in $group_list
	    group.output_attr
	end
end
	



def input_groups #might need some work but mostly done
    group_info = IO.readlines("C:\\Users\\Edward\\group_input.txt.txt", "r")
	for line in group_info #python code not sure if this breaks down lines from files
		indv_group_info = line.split(",")			#this command should break each line into individual words
		 #determining where input problem arises
		puts indv_group_info
		puts indv_group_info[0] #this does not produce any result
		new_group_obj = Group.new indv_group_info[0], indv_group_info[1], indv_group_info[2], indv_group_info[3], indv_group_info[4]		#the input error appears to be occurring here
		$group_list << new_group_obj		#not sure if this will work
	end
end

def input_events
    event_info = IO.readlines("C:\\Users\\Edward\\event_input.txt.txt", "r")
	for line in event_info
	    indv_event_info = line.split(",")		#not sure if this is a command in ruby
		new_event_obj = Event.new indv_event_info[0], indv_event_info[1]
		$event_list << new_event_obj
	end
end

def assign_first_choice #assigns all groups to their first choice's event list
    for group in $group_list #was class variable now is global
	    for event in $event_list #was class variable now is global
		    if group.find_choice_one == event.find_event_date			#changed to method
		       #this function is debugged 
			   event.add_to_attend_list(group)#changed to method				
		    end  #uncertain if this is passing any information along
		end      #that is I'm not certain if any groups are being added
	end          #to the event list, the test function is negative
end

def test_assign_first_choice
    for event in $event_list
	    puts event.find_group_attend_list
	end
end
#partially debugged this function
def find_over_capacity_under_capacity #returns 2 arrays
    over_capacity_events = Array.new
	under_capacity_events = Array.new
    for event in $event_list #was class variable now is global
	    attendance = 0
		group_attend_list = event.find_group_attend_list#passing variable from class method
		for group in group_attend_list
		    num_people = group.find_num_people #unsure if this is most expedient way
		    attendance += num_people			
		end
		event_capacity = event.find_event_capacity
		if attendance > event_capacity 
		    over_capacity_events << event
        else 
            under_capacity_events << event # not sure if this works in ruby
		end
			
	end
	return over_capacity_events, under_capacity_events #does this require an end as well?
end

def find_under_capacity #no longer required
end

def reassignment_second(over_capacity_events, under_capacity_events) #didn't run any test conditions
    for event in over_capacity_events
	    group_attend_list = event.find_group_attend_list #this seems unwieldy
	    for group in group_attend_list 
		    for under_capacity_event in under_capacity_events
			    choice_two = group.find_choice_two
				under_capacity_event_date = under_capacity_event.find_event_date
			    if under_capacity_event_date == choice_two#python code
				    under_capacity_event.add_to_attend_list(group)
					event.group_attend_list_delete (group)
				elsif event = over_capacity_events[over_capacity_events.length -1] and group = group_attend_list[group_attend_list.length - 1]
				    return false #not sure if this will break the while loop in main
				else
				    pass #python code
				end
					
			end
		end    
    end 
end

def reassignment_third(over_capacity_events, under_capacity_events) #no test conditions run read over
    for event in over_capacity_events 
		group_attend_list = event.find_group_attend_list
	    for group in group_attend_list 
		    for under_capacity_event in under_capacity_events
				choice_three = group.find_choice_three
				under_capacity_event_date = under_capacity_event.find_event_date
			    if under_capacity_event_date == choice_three
				    under_capacity_event.add_to_attend_list(group)
					event.group_attend_list_delete (group)
				elsif event = over_capacity_events[over_capacity_events.length -1] and group = group_attend_list[group_attend_list.length - 1]
				    return false
				else
				    pass #python code
				end
					
			end
		end    
    end 
end

def capacity_met
    over_capacity_events, under_capacity_events = find_over_capacity_under_capacity() #does this work in ruby?
	if over_capacity_events.length == 0
	    return true
	else 
	    return false
	end
end

def write_to_file #seems to be debugged file was written to with appropriate results given sample
    output_file = File.open("output.txt.txt", "w")
	for event in $event_list #was class variable now is global
	    event_date = event.find_event_date
		puts event_date #seems event_date and group_name are iterated more than once 
	    output_file.syswrite(event_date + " ")
		group_attend_list = event.find_group_attend_list
		for group in group_attend_list
		    group_name = group.find_group_name
			puts group_name
			output_file.syswrite(group_name + " ")
		end
		output_file.syswrite("\n")
	end
end

def write_error_to_file(over_capacity_events) #not debugged yet
    output_file = File.open("output.txt.txt","w")
	for event in over_capacity_events
	    output_file.syswrite(event)
		output_file.syswrite("is over capacity")
	end
end
	

main
