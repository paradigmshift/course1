def array_range(start, finish)
  (start..finish).to_a()
end

# Initializes a new board as a hash, keys are the positions and values are the symbols to be printed on the board
def new_board
  Hash[
    (0..186).to_a.map do |x|
      # location of where all the horizontal bars are
      horiz_bars = [5, 11, 22, 28, 39, 45, 73,79, 90, 96, 107, 113, 141, 158, 175, 147, 164, 181]
      # location of the "+" junctions
      junctions = [56, 62, 124, 130]
      # location of the dotted lines that demarcate the squares
      dotted_lines = array_range(51, 55).concat(array_range(57, 61)).concat(array_range(63, 67)).concat(array_range(119, 123)).concat(array_range(125, 129)).concat(array_range(131, 135))

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
  pos_to_slot = {1 => 19, 2 => 25, 3 => 31, 4 => 87, 5 => 93, 6 => 99, 7 => 155, 8 => 161, 9 => 167}
end

def pos_ok?(pos, board, pos_to_slot)
  if board[pos_to_slot[pos]] == " " then true else false end
end

def mark_pos(mark, pos, board, pos_to_slot)
  board[pos_to_slot[pos]] = mark
end

def draw_board(board)
  board_display = ""
  board.each do |k, v|
    board_display << board[k]
    if (k + 1) % 17 == 0 then board_display << "\n" end
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
  check([board[19], board[25], board[31]],
    [board[87], board[93], board[99]],
    [board[155], board[161], board[167]])
end

def check_vert(board)
  check([board[19], board[87], board[155]],
    [board[25], board[93], board[161]],
    [board[31], board[99], board[167]])
end

def check_diag(board)
  check([board[19], board[93], board[167]],
    [board[31], board[93], board[155]])
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

def start_game()
  board = new_board()
  loop do
    system "clear"
    puts draw_board(board)
    puts "Choose a position (1 to 9) to place a piece: "
    player = ""
    computer = ""
    loop do
      player = gets.chomp
      if pos_ok?(player.to_i, board, pos_to_slot())
        mark_pos("X", player.to_i, board, pos_to_slot())
        break
      end
    end
    system "clear"
    puts draw_board(board)
    if win?(board)
      who_won(win?(board))
      break
    end
    loop do
      computer = (1..9).to_a.sample # computer chooses position randomly
      break if pos_ok?(computer, board, pos_to_slot())
    end
    mark_pos("O", computer, board, pos_to_slot())
    system "clear"
    puts draw_board(board)
    if win?(board)
      who_won(win?(board))
      break
    end
  end
end

start_game()
