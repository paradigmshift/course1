class Hand
  attr_accessor :value
  include Comparable

  def initialize(value)
    self.value = value
  end


  def <=>(other_hand)
    if self.value == other_hand.value
      0
    elsif (self.value == 'p' && other_hand.value == 'r') ||
        (self.value == 'r' && other_hand.value == 's') ||
      (self.value == 's' && other_hand.value == 'p')
      1
    else
      -1
    end
  end

end

class Player

  attr_accessor :score, :hand, :choice
  attr_reader :name

  def initialize(name)
    @name = name
    self.score = 0
  end

  def to_s
    "#{name} chose #{Game::CHOICES[choice]}"
  end

end

class Human < Player

  def pick_hand
    begin
      puts "Pick one: (p/r/s)"
      self.choice = gets.chomp.downcase
    end until Game::CHOICES.include?(choice)
    self.hand = Hand.new(self.choice)
  end


end

class Computer < Player

  def pick_hand
    self.choice = Game::CHOICES.keys.sample
    self.hand = Hand.new(self.choice)
  end

end

class Game
  CHOICES = {'p' => 'Paper', 's' => 'Scissors', 'r' => "Rock"}

  def initialize
    puts "Please enter your name: "
    @player_name = gets.chomp
    @player = Human.new(@player_name)
    @computer = Computer.new("Computer")
  end

  def play
    begin
      system "clear"
      puts "Computer #{@computer.score}               Player #{@player.score}"
      @player.pick_hand
      @computer.pick_hand
      puts @player
      puts @computer
      puts compare_hands
      puts "Play again? (y/n)"
      play_again = gets.chomp.downcase
    end until play_again == 'n'
  end

  def compare_hands
    if @player.hand == @computer.hand
      "It's a tie"
    elsif @player.hand > @computer.hand
      @player.score += 1
      "You won"
    else
      @computer.score += 1
      "You lost!"
    end
  end

end

prs = Game.new
prs.play
