puts "Как тебя зовут?"
name = gets.chomp

puts "Какой твой рост?"
height = gets.chomp

ideal_weight = height.to_i - 110

if ideal_weight > 0 
    puts "Идеальный вес = #{ideal_weight}"
else
    puts "Ваш вес уже оптимальный"
end
