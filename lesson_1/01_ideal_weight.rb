puts "Как тебя зовут?"
name = gets.chomp

puts "Какой твой рост?"
height = gets.chomp.to_i

ideal_weight = height - 110

if ideal_weight.positive?
  puts "Идеальный вес = #{ideal_weight}"
else
  puts "Ваш вес уже оптимальный"
end
