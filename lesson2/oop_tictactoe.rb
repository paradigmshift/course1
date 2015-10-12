class Player

  attr_accessor :score, :name, :marker

  def initialize(name, marker)
    self.name = name
    self.score = 0
    self.marker = marker
  end

end

class Square

  attr_accessor :value

  def initialize
    self.value = ' '
  end

end

class Board

  attr_accessor :board_pos

  def initialize
    self.board_pos = {}
    (1..9).to_a.each {|pos| self.board_pos[pos] = Square.new}
  end

  def all_marked?
    empty_squares.length == 0
  end

  def empty_squares
    board_pos.select { |_, square| square.value == ' '}
  end

  def mark_square(pos, marker)
    board_pos[pos].value = marker
  end

  def draw_board
    system "clear"
    puts "     |     |     "
    puts "  #{board_pos[1].value}  |  #{board_pos[2].value}  |  #{board_pos[3].value}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board_pos[4].value}  |  #{board_pos[5].value}  |  #{board_pos[6].value}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board_pos[7].value}  |  #{board_pos[8].value}  |  #{board_pos[9].value}  "
    puts "     |     |     "
    puts ""
  end

end

class TicTacToe

  def initialize
    @human = Player.new("Some random guy", "X")
    @computer = Player.new("Computer", "O")
  end

  def new_board
    @board = Board.new
  end

  def play
    puts "Please enter your name: "
    @human.name = gets.chomp
    begin
      new_board
      @current_player = @human
      @board.draw_board
      begin
        puts "Computer: #{@computer.score}        #{@human.name}: #{@human.score}"
        current_player_turn
        @board.draw_board
        winnerp = check_winner
      end until winnerp || @board.all_marked?
      puts winnerp ? winnerp : "It's a tie!"
      puts "Play again? (y/n)"
      play_again = gets.chomp
    end until play_again.downcase == 'n'
  end

  def check_winner
    winning_pos = [[1,2,3], [4,5,6], [7,8,9], [1, 4, 7], [2,5,8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    winning_pos.each do |pos|
      if pos.map { |x| @board.board_pos[x].value }.all? { |x| x == @human.marker }
        @human.score += 1
        return "#{@human.name} wins!"
      elsif pos.map { |x| @board.board_pos[x].value }.all? { |x| x == @computer.marker }
        @computer.score += 1
        return "#{@computer.name} wins!"
      end
    end
    return nil
  end

  def current_player_turn
    if @current_player == @human
      begin
        puts "Select a position from 1 to 9: "
        begin
          pos = gets.chomp
        end until @board.empty_squares.keys.include?(pos.to_i)
        @board.mark_square(pos.to_i, @human.marker)
        @current_player = @computer
      end
    else
      @board.mark_square(@board.empty_squares.keys.sample, @computer.marker)
      @current_player = @human
    end
  end

end

TicTacToe.new.play
