module Menu 
	def menu
		"Welcome to the TodoList Program!
		Use the following menu options to get started
		1) Add
		2) Show
		3) Update
		4) Delete 
		5) Write to a File
		6) Read from a File
		7) Toggle Status
		Q) Quit "
	end
	def show
		menu
	end
end

module Promptable
	def prompt(message= "What would you like to do?", symbol= ':> ') 
		print message
		print symbol
		gets.chomp
	end
end

#List Class
class List
	attr_reader :all_tasks
	def initialize
		@all_tasks= []
	end

	def add(task)
		all_tasks << task
	end

	#method to delete
	def delete(task_number)
		all_tasks.delete_at(task_number - 1)
		puts "Task number #{task_number} has been deleted"
	end
	#method to update
	def update(task_number, task)
		all_tasks[task_number - 1]= task
		puts "Task number #{task_number} has been updated"
	end

	def show
		all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}"}
	end

	#method to write to a file
	def write_to_file(filename)
		output= @all_tasks.map(&:to_machine).join("\n")
		IO.write(filename, output)
	end
	#method to read from a file
	def read_from_file(filename)
		IO.readlines(filename).each do |line|
			status, *description = line.split(':')
			status = status.include?('X')
			add(AddTask.new(description.join(':').strip, status))
		end
	end

	def toggle(task_number)
		all_tasks[task_number - 1].toggle_status
	end

end



#Task Class 
class AddTask
	attr_reader :description
	attr_accessor :status
	def initialize(description, status= false)
		@description = description
		@status = status
	end

	def toggle_status
		@status= !completed?
	end
	def completed?
		status
	end
	
	#method to show description
	def to_s
		"#{represent_status} #{description}"
	end

	def to_machine
		"#{represent_status}: #{description}"
	end

	private
	def represent_status
		completed? ? '[X]' : '[ ]'
	end
end

#RUNNING THE PROGRAM
if __FILE__== "todo.rb"
	include Menu
	include Promptable
	my_list= List.new
	puts 'Please choose the number from the following list'
	  	until (user_input = prompt(show).downcase).include?'q'
	  		case user_input
	  		  when '1' 
	  		  	my_list.add(AddTask.new(prompt('What is the task you would like to accomplish?'))) 
	  		  when '2'
	  		  	puts my_list.show
	  		  when '3'
	  		  	puts my_list.show
	  		  	my_list.update(prompt('Which task would like to update?').to_i, AddTask.new(prompt('Task Description?')))
	  		  when '4'
	  		  	puts my_list.show
	  		  	my_list.delete(prompt('What task to delete?').to_i)
	  		  when '5'
	  		  	my_list.write_to_file(prompt("What is the filename you would like to write to?"))
	  		  when '6'
	  		  	begin
	  		  		my_list.read_from_file(prompt("What is the filename to read from?"))
	  		  	rescue Errno::ENOENT
	  		  		puts 'ALERT:File name not found, please verify your filename and/or path.'
	  		  	end
	  		  when '7'
	  		  	puts my_list.show
	  		  	my_list.toggle(prompt('Which would you like to toggle the status for?').to_i)
	  		  else 
	  		  	puts "Sorry, I did not understand your request."
	  		end
	  	end
	puts "Thanks for using the menu system!"
end


