def validate_str_num (i)
  i.each_char do |char|
    ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].include? char
  end
end

loop do

  puts "Enter first number: "
  a = gets.chomp
  if !validate_str_num(a)
    puts "Not a valid number"
    next
  end

  puts "Enter second number:"
  b = gets.chomp
  if !validate_str_num(b)
    puts "Not a valid number"
    next
  end

  puts "Enter operator"
  c = gets.chomp

  case c
  when "+"
    p a.to_f + b.to_f
  when "-"
    p a.to_f - b.to_f
  when "*"
    p a.to_f * b.to_f
  when "/"
    p a.to_f / b.to_f
  else
    puts "Not a valid operator"
  end
  puts "Redo? (y/n): "
  again = gets.chomp
  break unless again.downcase() == 'y'
end
