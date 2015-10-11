class Card

  attr_accessor :suit, :rank

  def initialize(suit, rank)
    self.suit = suit
    self.rank = rank
  end

  def to_s
    "#{rank} of #{suit}"
  end

end

class Deck

  attr_accessor :cards

  def initialize
    self.cards = []
    ['Diamonds', 'Hearts', 'Clubs', 'Spades'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each { |rank| cards << Card.new(suit, rank) }
    end
    cards.shuffle!
  end

  def deal_card
    cards.pop
  end

end

class Player

  attr_accessor :hand

  def initialize
    self.hand = []
  end

  def hit(deck)
    hand << deck.deal_card
  end

end

class Player1 < Player

  attr_accessor :name, :hand

  def initialize(name)
    super()
    self.name = name
  end

end

class Dealer < Player
end

class BlackJack

  attr_accessor :player, :dealer, :deck

  def initialize
    self.player = Player1.new("some random guy")
    self.dealer = Dealer.new
    self.deck = Deck.new
  end

  def enter_player_name
    player.name = gets.chomp
  end

  def initial_deal
    2.times do
      player.hit(deck)
      dealer.hit(deck)
    end
  end

  def check_blackjack(player_hand, dealer_hand)
    case
    when calculate_value(player_hand) == 21
      :player
    when calculate_value(dealer_hand) == 21
      :dealer
    else
      :nil
    end
  end

  def calculate_value(hand)
    total = 0
    hand.map do |card|
      card.rank.to_i == 0 && card.rank != 'Ace'? total += 10 : total += card.rank.to_i
    end

    hand.select { |card| card.rank =='Ace' }.count.times do # check for Aces and ajust accordingly
      total + 11 <= 21 ? total += 11 : total += 1
    end

    total
  end

  def run
    puts "Please enter the player's name: "
    initial_deal
    winner = check_blackjack(player.hand, dealer.hand)
    if winner
      puts winner
    end
  end

end
