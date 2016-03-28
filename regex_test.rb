#!/usr/bin/ruby

# Playground file to test regex's/string searching method 

line = "CS1110"

i = line.index(/[0-9]/)

p Integer(line[i..-1])

line = "ORIE31"

i = line.index(/[0-9]/)

p Integer(line[i..-1])

line = "ORIE"

i = line.index(/[0-9]/)

if i == nil 
	p line
end 


def num_compare(num, c)
	course_num = c
	div = 1000 
	while(div > 0) do 
		if num == c/div
			return true 
		end 
		div = div/10 
	end 
	return false 
end 

p num_compare(212, 2112)
