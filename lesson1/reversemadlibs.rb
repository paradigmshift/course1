dictionary = { :noun => ['Girl', 'Boy', 'Italy', 'Cat', 'Dog', 'France', 'Germany'],
  :verb => ['walk', 'run', 'crawl', 'drink', 'eat', 'bike', 'skate'],
  :adjective => ['beautiful', 'pretty', 'ugly', 'terrible', 'horrendous', 'mad', 'boiling', 'bored', 'brainy', 'brave', 'breakable', 'breeze', 'bright', 'broken', 'bumpy']}

def error_msg(message)
  puts "=> #{message}"
end

def exit_with(message)
  error_msg(message)
  exit
end

exit_with("No input file") if ARGV.empty?
exit_with("File doesn't exist") if !File.exists?(ARGV[0])

file_contents = File.open(ARGV[0], 'r') do |f|
  f.read
end

def replace_occurences_rand(str, original, rand_collection)
   str.gsub!(original).each do |word|
    rand_collection.sample
  end
end

dictionary.each do |k, v|
  replace_occurences_rand(file_contents, k.to_s.upcase, v)
end

puts file_contents
