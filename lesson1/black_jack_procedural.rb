def calculate_total(hand)
  total = 0
  hand.map do |card|
    card[1].to_i == 0 && card[1] != 'A'? total += 10 : total += card[1].to_i
  end

  hand.select { |card| card[1] =='A' }.count.times do # check for Aces and ajust accordingly
    total + 11 <= 21 ? total += 11 : total += 1
  end

  total
end

puts "Please enter your name:"
player_name = gets.chomp

# deal cards
loop do
  system "clear"
  player_total = 0
  dealer_total = 0
  play_again = nil
  player_hand = []
  dealer_hand = []

  rank = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  suits = ['D', 'S', 'C', 'H']

  deck = []

  4.times do
    suits.product(rank).map do |card|
      deck << card
    end
  end

  deck.shuffle!


  2.times { player_hand << deck.pop }
  2.times { dealer_hand << deck.pop }

  # check for blackjack

  player_total = calculate_total(player_hand)
  dealer_total = calculate_total(dealer_hand)

  # show dealer's first card
  puts "Dealer has #{dealer_hand[1]}"
  puts "#{player_name}'s'hand is #{player_hand}, with a total value of #{player_total}. "
  # player hit or stay

  if player_total == 21
    puts "Blackjack! #{player_name} wins!"
    puts "Play again? (y/n)"
    play_again = gets.chomp
    play_again.downcase == 'y' ? next : break
  end

  while player_total < 21
    puts "Press 1 to Hit or 2 to stay: "
    hit_or_stay = gets.chomp
    if !['1', '2'].include?(hit_or_stay)
      puts "Please enter 1 or 2"
      next
    end
    break if hit_or_stay == '2'
    new_card = deck.pop
    puts "Dealing #{new_card}"
    player_hand << new_card
    player_total = calculate_total(player_hand)
    puts "#{player_name}'s' Hand is #{player_hand}, with a total value of #{player_total}. "
    puts "Blackjack! #{player_name} wins!" if player_total ==21
  end

  if player_total > 21
    puts "Bust! Dealer wins!"
    puts "Play again? (y/n)"
    play_again = gets.chomp
    play_again.downcase == 'y' ? next : break
  end

  if dealer_total == 21
    puts "Dealer hit Blackjack! #{player_name} lost!"
    puts "Play again? (y/n)"
    play_again = gets.chomp
    play_again.downcase == 'y' ? next : break
  end

  while dealer_total < 17
    new_card = deck.pop
    puts "Dealing #{new_card} to dealer"
    dealer_hand << new_card
    dealer_total = calculate_total(dealer_hand)
    puts "Dealer's total is now: #{dealer_total}"
    puts "Dealer hit Blackjack! #{player_name} lose!" if dealer_total == 21
  end

  if dealer_total > 21
    puts "Dealer Busted! #{player_name} wins!"
    puts "Play again? (y/n)"
    play_again = gets.chomp
    play_again.downcase == 'y' ? next : break
  end

  puts "#{player_name}'s' hand, total of #{player_total}:"
  player_hand.each { |card| p card }
  puts ""
  puts "Dealer's hand, total of #{dealer_total}:"
  dealer_hand.each { |card| p card }
  puts ""

  if dealer_total < player_total
    puts "#{player_name} wins!"
  elsif dealer_total > player_total
    puts "#{player_name} lost!"
  else
    puts "It's a tie!"
  end

  puts "Play again? (y/n)"
  play_again = gets.chomp
  break if play_again.downcase == 'n'
end
