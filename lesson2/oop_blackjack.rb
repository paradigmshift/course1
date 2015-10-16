class Card
  attr_accessor :rank, :suit
  def initialize(rank, suit)
    self.rank = rank
    self.suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  attr_accessor :cards
  def initialize(number_of_decks=1)
    self.cards = []
    number_of_decks.times do
      ["Hearts", "Diamonds", "Spades", "Clubs"].each do |suit|
        ['2', '3', '4', '5', '6', '7', '8', '9', '10',
          'Jack', 'Queen', 'King', 'Ace'].each { |rank| cards << Card.new(rank, suit) }
      end
    end
    cards.shuffle!
  end

  def deal_card
    cards.pop
  end
end

class Player
  attr_accessor :name, :hand, :score
  def initialize(name)
    self.name = name
    self.hand = []
    self.score = 0
  end

  def hit(deck)
    hand << deck.deal_card
  end

  def show_hand
    str = ""
    if hand.length > 2
      hand[0, hand.length - 1].each { |card| str << "#{card}, " }
      str << "and #{hand.last}"
    else
      str << "#{hand.first} and #{hand.last}"
    end
  end

  def get_name
    puts "Please enter your name: "
    self.name = gets.chomp
  end

end

class BlackJack

  def initialize
    @player = Player.new("some random guy")
    @dealer = Player.new("Dealer")
    @deck = Deck.new(4)
  end

  def initial_deal
    system "clear"
    @player.hand = []
    @dealer.hand = []
    2.times do
      @player.hit(@deck)
      @dealer.hit(@deck)
    end
    @current_player = @player
  end

  def current_player_turn
    if @current_player == @player
      system "clear"
      puts "#{@dealer.name}: #{@dealer.score}                  #{@player.name}: #{@player.score}"
      puts "Your cards are #{@player.show_hand}, with a total value of #{calculate_value(@player.hand)}.\n
#{@dealer.name} has #{@dealer.hand.last}. (H)it or (s)tay?: "
      hit_or_stay = gets.chomp.downcase
      @player.hit(@deck) if hit_or_stay == 'h'
      @current_player = @dealer if hit_or_stay == 's'
    else
      @dealer.hit(@deck)
    end
  end

  def calculate_value(hand)
    total = 0
    hand.map do |card|
      card.rank.to_i == 0 && card.rank != 'Ace'? total += 10 : total += card.rank.to_i
    end

    hand.select { |card| card.rank == 'Ace' }.count.times do # check for Aces and ajust accordingly
      total + 11 <= 21 ? total += 11 : total += 1
    end
    total
  end

  def blackjack?(player)
    calculate_value(player.hand) == 21
  end

  def bust?(player)
    calculate_value(player.hand) > 21
  end

  def compare_hands
    str = "#{@player.name}'s hand is #{@player.show_hand}, with a value of #{calculate_value(@player.hand)}.\n
#{@dealer.name}'s hand is #{@dealer.show_hand}, with a value of #{calculate_value(@dealer.hand)}.\n"
    if calculate_value(@player.hand) > calculate_value(@dealer.hand)
      str << "#{@player.name} wins!"
      @player.score += 1
    else
      str << "#{@dealer.name} wins!"
      @dealer.score += 1
    end
    str
  end

  def other_player(player)
    case player
    when @dealer
      @player
    else
      @dealer
    end
  end

  def run
    @player.get_name
    begin
      initial_deal
      case
      when blackjack?(@player)
        true
      when blackjack?(@dealer)
        @current_player = @dealer
      else
        begin
          current_player_turn
        end until bust?(@current_player) || blackjack?(@current_player) ||
          calculate_value(@dealer.hand) > 17 && @current_player = @dealer
      end
      case
      when blackjack?(@current_player)
        message =  "#{@current_player.name} hit blackjack!"
        @current_player.score += 1
      when bust?(@current_player)
        message =  "#{@current_player.name} busted!"
        other_player(@current_player).score += 1
      else
        message = compare_hands
      end
      puts message
      puts "Play again?: "
      play_again = gets.chomp.downcase
    end until play_again == 'n'
  end
end

BlackJack.new.run
