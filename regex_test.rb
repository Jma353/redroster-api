#!/usr/bin/ruby

# Playground file to test regex's/string searching method 


line = "11:45PM"

p line[0...(line.index(":"))]
p line[(line.index(/[A-Za-z]/))..-1]





def start_hour(start_time)
	hour_string = start_time[0...(start_time.index(":"))]
	am_or_pm = start_time[(start_time.index(/[A-Za-z]/))..-1]
	Integer(hour_string) + (am_or_pm.upcase == "PM" ? 12 : 0)
end


p start_hour(line)




p "MWF".split("")