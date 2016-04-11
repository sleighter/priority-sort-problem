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
	
	def find_group_attendance
		attendance = 0
		for group in @group_attend_list
			attendance += group.find_num_people
		end
		return attendance
	end
	
	def output_attr
		puts "The event date is:"
	    puts @event_date
		puts "The event capacity is:"
		puts @event_capacity
		puts "The attendance list is:"
		puts @group_attend_list
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
	end
	reassignment_switch1 = true #the variables are correctly being passed to the reassignment function
	while over_capacity_events.length > 0 and reassignment_switch1 == true
	    reassignment_switch1 = reassignment_second(over_capacity_events, under_capacity_events)
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
		indv_group_info = line.split(",")		#this command should break each line into individual words
		  #the above for loop is now unnecessary and can be removed
		counter_array = Array.new(indv_group_info.length/6){|index| index*6}#might need to round down
		for number in counter_array
		    new_group_obj = Group.new indv_group_info[number+1], indv_group_info[number+2], indv_group_info[number+3], indv_group_info[number+4], indv_group_info[number+5]
			$group_list << new_group_obj
		end
		#determining where input problem arises
		#puts indv_group_info.class
		#puts indv_group_info[0]		#this does not produce any result
		#puts indv_group_info.length
		#new_group_obj = Group.new indv_group_info[0], indv_group_info[1], indv_group_info[2], indv_group_info[3], indv_group_info[4]		#the input error appears to be occurring here
		#$group_list << new_group_obj		#not sure if this will work
	end
end

def input_events
    event_info = IO.readlines("C:\\Users\\Edward\\event_input.txt.txt", "r")
	for line in event_info
	    indv_event_info = line.split(",")
		counter_array = Array.new(indv_event_info.length/3) {|index| index*3}#not sure if this is a command in ruby
		for number in counter_array
			new_event_obj = Event.new indv_event_info[number+1], indv_event_info[number+2]
			$event_list << new_event_obj
		end
	
	
	end
end
#this function is only working for the first event
def assign_first_choice #assigns all groups to their first choice's event list
    for event in $event_list
		#puts group.find_choice_one
		#was class variable now is global
	    for group in $group_list
		    group_date = group.find_choice_one
			event_date = event.find_event_date
			#was class variable now is global
			x = group_date <=> event_date
			if x == 0			#changed to method 
			    event.add_to_attend_list(group)
				#changed to method				
		    end  #uncertain if this is passing any information along
		end      #that is I'm not certain if any groups are being added
	end
	#to the event list, the test function is negative
end

def test_assign_first_choice
    for event in $event_list
	    puts event.find_group_attend_list
	end
end
#partially debugged this function
def find_over_capacity_under_capacity #returns 2 arrays appears to produce results
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

#def reassignment_second(over_capacity_events, under_capacity_events) #didn't run any test conditions
	
#	for event in over_capacity_events
#	    group_attend_list = event.find_group_attend_list
#		#this seems unwieldy
#	    for group in group_attend_list 
#		    for under_capacity_event in under_capacity_events
#			    choice_two = group.find_choice_two
#				under_capacity_event_date = under_capacity_event.find_event_date
#				switch = under_capacity_event_date <=> choice_two
#			    if switch == 0
#				    puts "Successful reassignment" #python code
#				    under_capacity_event.add_to_attend_list(group)
#					event.group_attend_list_delete (group)
#				elsif event == over_capacity_events.last and group == group_attend_list.last
#				    return false #not sure if this will break the while loop in main
#				else
				#python code
#				end
					
#			end
#		end    
#   end 
#end

def reassignment_second(over_capacity_events, under_capacity_events) #no test conditions run read over
    while over_capacity_events.length > 0
		
		for event in over_capacity_events
				group_attend_list = event.find_group_attend_list
				puts group_attend_list
				puts "end of group attend list"
				for group in group_attend_list
					puts group.find_group_name
					over_capacity_events, under_capacity_events = find_over_capacity_under_capacity
					puts group.find_choice_two
					for under_capacity_event in under_capacity_events
						choice_two = group.find_choice_two
						under_capacity_event_date = under_capacity_event.find_event_date
						if under_capacity_event_date == choice_two
							puts "Successful reassigment to second choice"
							under_capacity_event.add_to_attend_list(group)
							event.group_attend_list_delete (group)
						
						elsif event == over_capacity_events.last and group == group_attend_list.last
							for group2 in group_attend_list
								puts event.find_event_date
								puts group2.find_group_name
							end
							puts event.find_event_date
							puts group.find_group_name
							puts "You returned false"
							return false
						else
						 #python code
						end
					end
				end	
			
		end    
    end 
end



def reassignment_third(over_capacity_events, under_capacity_events) #no test conditions run read over
    while over_capacity_events.length > 0
		
		for event in over_capacity_events
				group_attend_list = event.find_group_attend_list
				puts group_attend_list
				puts "end of group attend list"
				for group in group_attend_list
					puts group.find_group_name
					over_capacity_events, under_capacity_events = find_over_capacity_under_capacity
					puts group.find_choice_three
					for under_capacity_event in under_capacity_events
						choice_three = group.find_choice_three
						under_capacity_event_date = under_capacity_event.find_event_date
						if under_capacity_event_date == choice_three
							puts "Successful reassigment to third choice"
							under_capacity_event.add_to_attend_list(group)
							event.group_attend_list_delete (group)
						
						elsif event == over_capacity_events.last and group == group_attend_list.last
							for group2 in group_attend_list
								puts event.find_event_date
								puts group2.find_group_name
							end
							puts event.find_event_date
							puts group.find_group_name
							puts "You returned false"
							return false
						else
						 #python code
						end
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
	    #seems event_date and group_name are iterated more than once 
	    output_file.syswrite(event_date + " total capacity: " + event.find_event_capacity.to_s + " ")
		group_attend_list = event.find_group_attend_list
		for group in group_attend_list
		    group_name = group.find_group_name
			output_file.syswrite(group_name + " ")
			output_file.syswrite("(current attendance: " + event.find_group_attendance.to_s + ")")
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
