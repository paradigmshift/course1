# Initializes a new board as a hash, keys are the positions and values are the symbols to be printed on the board
def new_board
  Hash[
    (0..186).to_a.map do |x|
      # location of where all the horizontal bars are
      horiz_bars = [5, 11, 22, 28, 39, 45, 73,79, 90, 96, 107, 113, 141, 158, 175, 147, 164, 181]
      # location of the "+" junctions
      junctions = [56, 62, 124, 130]
      # location of the dotted lines that demarcate the squares
      dotted_lines = [*51..55, *57..61, *63..67, *119..123, *125..129, *131..135]

      case
      when horiz_bars.include?(x)
        [x, "|"]
      when junctions.include?(x)
        [x, "+"]
      when dotted_lines.include?(x)
        [x, "-"]
      else
        [x, " "]
      end
    end]
end

# Player entered position (1 to 9) mapped to board positions where the pieces go
def pos_to_slot()
  {1 => 19, 2 => 25, 3 => 31, 4 => 87, 5 => 93, 6 => 99, 7 => 155, 8 => 161, 9 => 167}
end

def pos_ok?(pos, board, pos_to_slot)
  board[pos_to_slot[pos]] == " "
end

def mark_pos(mark, pos, board, pos_to_slot)
  board[pos_to_slot[pos]] = mark
end

def draw_board(board)
  board_display = ""
  board.each do |k, v|
    board_display << v 
    board_display << "\n" if (k + 1) % 17 == 0
  end
  board_display
end

def same_val?(pos1, pos2, pos3)
  pos1 == pos2 && pos2 == pos3 && pos1 != " "
end

def check(*pos)
  mark = false
  pos.each do |row|
    if same_val?(row[0], row[1], row[2]) then mark = row[1] end
  end
  mark
end

def check_horiz(board)
  check(board.values_at(19, 25, 31),
    board.values_at(87, 93, 99),
    board.values_at(155, 161, 167))
end

def check_vert(board)
  check(board.values_at(19, 87, 155),
    board.values_at(25, 93, 161),
    board.values_at(31, 99, 167))
end

def check_diag(board)
  check(board.values_at(19, 93, 167),
    board.values_at(31, 93, 155))
end

def match_tied?(board)
  !board.values_at(19, 25, 31, 87, 93, 99, 155, 161, 167).include?(" ")
end

# return the winning piece if existing, otherwise return false
def win?(board)
  checks = [method(:check_horiz), method(:check_vert), method(:check_diag)]
  checks.each do |fn|
    if fn.call(board)
      return fn.call(board)
    end
  end
  false
end

def who_won(mark)
  if mark == "X"
    puts "Player won!"
  else
    puts "Computer won!"
  end
end

def player_loop(board, computer=nil)
  player = ""
  mark = ""
  loop do
    if computer
      player = (1..9).to_a.sample
      mark = "O"
    else
      puts "Choose a position (1 to 9) to place a piece: "
      player = gets.chomp
      mark = "X"
    end
    break unless !pos_ok?(player.to_i, board, pos_to_slot)
  end
  mark_pos(mark, player.to_i, board, pos_to_slot)
  system "clear"
  puts draw_board(board)
end

def check_win(board)
  if win?(board)
    who_won(win?(board))
  end
end

def start_game()
  board = new_board()
  loop do
    system "clear"
    puts draw_board(board)
    player_loop(board)
    check_win(board)
    if win?(board) || match_tied?(board)
      break
    end
    player_loop(board, :computer)
    check_win(board)
    break unless !win?(board)
  end
end

start_game()
