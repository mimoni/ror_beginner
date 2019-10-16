vowel = %w[a e o u i]
result = {}

('a'..'z').each_with_index do |value, index|
  result[value] = index + 1 if vowel.include? value
end

p result
