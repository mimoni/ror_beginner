puts 'Вычисление дискриминанта и корней'
print 'Введите a: '
a = gets.chomp.to_f

print 'Введите b: '
b = gets.chomp.to_f

print 'Введите c: '
c = gets.chomp.to_f

d = b**2 - 4 * a * c

if d > 0
  x1 = (-b + Math.sqrt(d)) / (2 * a)
  x2 = (-b - Math.sqrt(d)) / (2 * a)
  puts "Дискриминант = #{d}. Корни x1 = #{x1}, x2 = #{x2}"
elsif d.zero?
  x = -b / (2 * a)
  puts "Дискриминант = #{d.to_i}. Корень = #{x}"
else
  puts "Дискриминант = #{d}. Корней нет."
end
