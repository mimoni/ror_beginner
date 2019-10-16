array = [0, 1]

while (next_value = array[-2] + array[-1]) < 100
  array << next_value
end

p array
