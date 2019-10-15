print 'Введите 1 сторону треугольника: '
a = gets.chomp.to_f

print 'Введите 2 сторону треугольника: '
b = gets.chomp.to_f

print 'Введите 3 сторону треугольника: '
c = gets.chomp.to_f

(a,b,h) = [a, b, c].sort

result = 'Треугольник: '

if h ** 2 == (a ** 2 + b ** 2)
  result << 'прямоугольный'
else
  result << 'не прямоугольный'
end

result << ', равнобедренный' if a == b || b == h || h == a

result << ', равносторонний' if a == b && b == h

puts result
