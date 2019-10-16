puts 'Введи  число, месяц, год (через пробел). Например 9 8 2017'
date = gets.chomp
day, month, year = date.split(' ').map(&:to_i)

def leap_year?(year)
  (year % 4).zero? && !(year % 100).zero? || (year % 400).zero?
end

def days_in_month(month, year)
  days = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  days[2] = 29 if leap_year? year
  days[month]
end

result = (1...month).reduce(0) do |sum, month|
  sum + days_in_month(month, year)
end

puts "Порядковый номер даты: #{result + day}"
