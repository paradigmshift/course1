# Cards are represented mathematically; Rank is represented by the numbers 1 - 10, 11 -> Jack, 12 -> Queen, 13 -> King, and 14 -> Ace. Suit is similar, with 0 -> Diamonds, 1 -> Clubs, 2 -> Spades, and 3 -> Hearts.

def display_rank(i)
  rank = Hash[(2..10).to_a.map do |x|
      [x, x]
    end
  ].merge({ 11 => :jack,
    12 => :queen,
    13 => :king,
    14 => :ace})

  rank[i]
end

def display_suit(i)
  suit = { 0 => :diamonds,
    1 => :clubs,
    2 => :spades,
    3 => :hearts}

  suit[i]
end

def display_card(card)
  "#{display_rank(card[0])} of #{display_suit(card[1])}"
end

def generate_deck()
  deck = []
  [0, 1, 2, 3].map do |suit|
    (2..14).to_a.each { |rank| deck.push([rank, suit]) }
  end
  deck
end

def shuffle_deck(deck)
  1000.times do
    deck.insert(rand(deck.length), deck.delete_at(rand(deck.length)))
  end
  deck
end

def generate_playing_deck()
  deck = []
  4.times do
    deck.concat(shuffle_deck(generate_deck))
  end
  deck
end

def card_at_random(deck)
  deck.delete_at(rand(deck.length))
end

def convert_aces(hand)
  aces = hand.select { |card| card[0] ==14 }
  aces.each { |card| hand.delete(card) }
  aces.each do |card|
    11 + check_card_val(hand) > 21 ? card[0] = 1 : card[0] = 11
    hand << card
  end
end

def check_card_val(deck) # receives array of 2 array elements, [[3,2], [4,1]]
  royals = [11, 12, 13] # jack, queen, king
  converted_deck = deck.map { |card| card.clone }
  converted_deck.map do |card| # replaces jack, queen, king with value of 10
    card[0] = 10 if royals.include?(card[0])
  end

  convert_aces(converted_deck) if deck.flatten.include?(14)
  converted_deck.map { |card| card[0] }.reduce(:+)
end

def hit(deck)
  card_at_random(deck)
end

def player_loop(deck, dealer=nil)
  player_deck = []
  2.times { player_deck.push(card_at_random(deck))}
end

def blackjack?(hand)
  check_card_val(hand) == 21 ? hand : nil
end

def deal_first_hand(deck)
  player_deck = []
  dealer_deck = []
  [player_deck, dealer_deck].each do |pdeck|   # deals 2 cards each to dealer
    2.times { pdeck.push(card_at_random(deck))}# and player
  end
  return player_deck, dealer_deck
end

def blackjack_msg(hand, dealer=nil)
  if dealer
    winner = "Dealer"
  else
    winner = "Player"
  end
  puts "#{winner} has #{display_card(hand[0])} and #{display_card(hand[1])}, blackjack!"
end

def bust_msg(hand, dealer=nil)
  msg = ""
  dealer ? busted = "Dealer" : busted = "Player"
  msg << "#{busted} has busted!\n"
  hand.each { |card| msg << "#{display_card(card)}\n" }
  msg
end

def bust?(hand)
  check_card_val(hand) > 21 ? true : false
end

def player_loop(hand, deck)
  loop do
    system "clear"
    puts "Your hand: "
    hand.each { |card| puts "#{display_card(card)}" }
    puts "Total value: #{check_card_val(hand)}, Press 1 to hit, 2 to stay: "
    action = gets.chomp
    break if action.to_i == 2
    # hand << card_at_random(deck)
    hand << hit(deck)
    break if bust?(hand)
  end
end

def dealer_loop(hand, deck)
  loop do
    hand << hit(deck) if check_card_val(hand) < 17
    break if check_card_val(hand) >= 17
  end
end

def decide_winner(dealer_hand, player_hand)
  check_card_val(dealer_hand) > check_card_val(player_hand) ? 1 : 0
end

def winner_msg(dealer=nil)
  dealer ? winner = "Dealer" : winner = "Player"
  puts "#{winner} won!"
end

def show_dealer_cards(hand)
  puts "Dealer's hand: "
  hand.each { |card| puts "#{display_card(card)}" }
  puts "Total value: #{check_card_val(hand)}"
end

def pls_press_enter_key()
  puts "Please press ENTER to continue"
  gets
end

def show_score(player_score, dealer_score)
  puts "Player's score is: #{player_score}"
  puts "Dealer's score is: #{dealer_score}"
end

def status_msg_and_update(player_score, dealer_score, msg, dealer=nil)
  system "clear"
  puts msg
  dealer ? dealer_score += 1 : player_score += 1
  show_score(player_score, dealer_score)
  pls_press_enter_key
  return player_score, dealer_score
end

def game_loop()
  deck = generate_playing_deck
  player_score = 0
  dealer_score = 0
  loop do
    player_hand, dealer_hand = deal_first_hand(deck)
    if blackjack?(player_hand)
      # blackjack_msg(player_hand)
      # player_score += 1
      # show_score(player_score, dealer_score)
      # pls_press_enter_key
      player_score, dealer_score = status_msg_and_update(player_score, dealer_score, blackjack_msg(player_hand))
      next
    elsif blackjack?(dealer_hand)
      # blackjack_msg(dealer_hand, :dealer)
      # dealer_score += 1
      # show_score(player_score, dealer_score)
      # pls_press_enter_key
      player_score, dealer_score = status_msg_and_update(player_score, dealer_score, blackjack_msg(dealer_hand, :dealer), :dealer)
      next
    end
    player_loop(player_hand, deck)
    if bust?(player_hand)
      # bust_msg(player_hand)
      # dealer_score += 1
      # show_score(player_score, dealer_score)
      # pls_press_enter_key
      player_score, dealer_score = status_msg_and_update(player_score, dealer_score, bust_msg(player_hand), :dealer)
      next
    end
    dealer_loop(dealer_hand, deck)
    if bust?(dealer_hand)
      # bust_msg(dealer_hand, :dealer)
      # player_score += 1
      # show_score(player_score, dealer_score)
      # pls_press_enter_key
      player_score, dealer_score = status_msg_and_update(player_score, dealer_score, bust_msg(dealer_hand, :dealer))
      next
    end
    show_dealer_cards(dealer_hand)
    case decide_winner(dealer_hand, player_hand)
    when 1
      winner_msg(:dealer)
      dealer_score += 1
    when 0
      winner_msg()
      player_score += 1
    end
    show_score(player_score, dealer_score)
    puts "Play again? (y/n): "
    answer = gets.chomp
    break if answer.downcase == 'n'
  end
end

game_loop
