def decide_winner(player1, player2)
  case 
  when player1 == "p" && player2 == "r"
    "Paper wraps rock, you won!"
  when player1 == "p" && player2 == "s"
    "Paper is cut by Scissors, you lost!"
  when player1 == "r" && player2 == "s"
    "Rock smashes Scissors, you won!"
  when player1 == "r" && player2 == "p"
    "Rock is wrapped by paper, you lost!"
  when player1 == "s" && player2 == "p"
    "Scissors cuts paper, you won!"
  when player1 == "s" && player2 == "r"
    "Scissors is smashed by rock, you lost!"
  else
    "It's a tie"
  end
end

loop do
  hand = {"p"=>"Paper", "r"=>"Rock", "s"=>"Scissors"}
  puts "Choose One: (P/R/S)"
  player = gets.chomp
  computer = ["p", "r", "s"].sample()
  puts "You picked #{hand[player]} and Computer picked #{hand[computer]}"
  puts decide_winner(player, computer)
  puts "Play Again? (Y/N)"
  again = gets.chomp
  break unless again.downcase() == 'y' 
end
