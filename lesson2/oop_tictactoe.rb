class Player

  attr_accessor :score, :name

  def initialize(name)
    self.name = name
    self.score = 0
  end

end

class Human < Player

  def place_piece(board_pos)
    begin
      begin
        puts "Choose a position from 1 to 9: "
        pos = gets.chomp.to_i
      end until (1..9).to_a.include?(pos)
    end until board_pos[pos - 1] == ' ' # input domain is 1 - 9 but board_pos
    pos - 1                             # index is 0 -8 thus input - 1
  end

end

class Computer < Player

  def place_piece(board_pos)
    begin
      pos = (0..8).to_a.sample
    end until board_pos[pos] == ' '
    pos
  end

end

class TicTacToe

  attr_accessor :board_pos

  def initialize
    @player = Human.new("Some random guy")
    @computer = Computer.new("Computer")
  end

  def new_board
    self.board_pos = []
    (0..8).each { |pos| self.board_pos[pos] = ' ' }
  end

  def get_name
    puts "Please enter your name: "
    player_name = gets.chomp
  end

  def draw_board
    system "clear"
    puts "     |     |     "
    puts "  #{board_pos[0]}  |  #{board_pos[1]}  |  #{board_pos[2]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board_pos[3]}  |  #{board_pos[4]}  |  #{board_pos[5]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board_pos[6]}  |  #{board_pos[7]}  |  #{board_pos[8]}  "
    puts "     |     |     "
    puts ""
    puts "Computer: #{@computer.score}        #{@player.name}: #{@player.score}"
  end

  def board_full?
    if self.board_pos.find { |x| x == " " }
      return nil
    else
      "It's a tie"
    end
  end

  def check_winner
    winning_pos = [[0,1,2], [3,4,5,], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    winning_pos.each do |pos|
      if pos.map { |x| board_pos[x] }.all? { |x| x == "X" }
        @player.score += 1
        return "#{@player.name} wins!"
      elsif pos.map { |x| board_pos[x] }.all? { |x| x == "O" }
        @computer.score += 1
        return "#{@computer.name} wins!"
      end
    end
    return nil
  end

  def player_turn
    board_pos[@player.place_piece(board_pos)] = "X"
  end

  def computer_turn
    board_pos[@computer.place_piece(board_pos)] = "O"
  end

  def play
    @player.name = get_name
    begin
      new_board
      begin
        draw_board
        player_turn
        who_won = check_winner
        break if who_won != nil || board_full? != nil
        computer_turn
        who_won = check_winner
      end until who_won != nil
      result = board_full? ? board_full? : who_won
      draw_board
      puts result
      puts "Play again? (y/n)"
      play_again = gets.chomp.downcase
    end until play_again == 'n'
  end

end

game = TicTacToe.new
game.play
