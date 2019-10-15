puts "основание треугольника"
a = gets.chomp.to_f

puts "высота треугольника?"
h = gets.chomp.to_f

area = (0.5 * a * h).round 3
puts "Площадь треугольника равна #{area}"
