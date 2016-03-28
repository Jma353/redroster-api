#!/usr/bin/ruby

line = "CS1110"

i = line.index(/[0-9]/)

p Integer(line[i..-1])

line = "ORIE31"

i = line.index(/[0-9]/)

p Integer(line[i..-1])