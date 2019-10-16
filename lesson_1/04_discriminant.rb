puts 'Вычисление дискриминанта и корней'
print 'Введите a: '
a = gets.chomp.to_f

print 'Введите b: '
b = gets.chomp.to_f

print 'Введите c: '
c = gets.chomp.to_f

root = Math.sqrt(d)

if d.positive?
  d = b ** 2 - 4 * a * c
  x1 = (-b + root) / (2 * a)
  x2 = (-b - root) / (2 * a)
  puts "Дискриминант = #{d}. Корни x1 = #{x1}, x2 = #{x2}"
elsif d.zero?
  x = -b / (2 * a)
  puts "Дискриминант = #{d.to_i}. Корень = #{x}"
else
  puts "Дискриминант = #{d}. Корней нет."
end
