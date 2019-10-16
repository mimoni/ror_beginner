products = {}

puts 'Для завершения ввода наберите стоп или stop'

loop do
  print 'Введите название товара: '
  name = gets.chomp
  break if %w[стоп stop].include? name

  print 'Введите цену: '
  price = gets.to_f

  print 'Кол-во товара: '
  count = gets.to_f

  puts '-' * 20
  products[name] = { price: price, count: count }
end

print "\n", 'Наименование товара'.rjust(20), 'Цена'.rjust(11)
print 'Кол-во'.rjust(11), 'Соимость'.rjust(16), "\n"

total_cost = 0
products.each do |product, details|
  price = details[:price]
  count = details[:count]
  sum = price * count
  total_cost += sum

  puts format('%20s %10.2f %10.2f %15.2f', product, price, count, sum)
end

puts "\n Общая стоимость: #{total_cost.round(2)}"
