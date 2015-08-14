#!/usr/bin/env ruby
require_relative 'player'
require_relative 'dummy'
require_relative 'randomPlayer'
require_relative 'tateti'

# With this method, player 1 will try to learn
def train_first(player1, player2, runs)
  tateti = Tateti.new
  p1 = 0
  p2 = 0
  ties = 0
  runs.times do
    loop do
      tateti = player1.play_to_learn(tateti, player2)
      break p1 += 1 if !tateti.winner.nil?
      break ties += 1 if tateti.tie?
      tateti = player2.play(tateti)
      break p2 += 1 if !tateti.winner.nil?
      break ties += 1 if tateti.tie?
    end
    tateti.empty_board
  end
  print_stats(player1, player2, runs, p1, p2, ties)
end

# With this method, player 2 will try to learn
def train_second(player1, player2, runs)
  tateti = Tateti.new
  p1 = 0
  p2 = 0
  ties = 0
  runs.times do
    loop do
      tateti = player1.play(tateti)
      break p1 += 1 if !tateti.winner.nil?
      break ties += 1 if tateti.tie?
      tateti = player2.play_to_learn(tateti, player1)
      break p2 += 1 if !tateti.winner.nil?
      break ties += 1 if tateti.tie?
    end
    tateti.empty_board
  end
  print_stats(player1, player2, runs, p1, p2, ties)
end

# Players will play according to what they know
def simulate(player1, player2, runs)
  tateti = Tateti.new
  p1 = 0
  p2 = 0
  ties = 0
  runs.times do
    loop do
      tateti = player1.play(tateti)
      break p1 += 1 if !tateti.winner.nil?
      break ties += 1 if tateti.tie?
      tateti = player2.play(tateti)
      break p2 += 1 if !tateti.winner.nil?
      break ties += 1 if tateti.tie?
    end
    tateti.empty_board
  end
  print_stats(player1, player2, runs, p1, p2, ties)
end

def print_stats(player1, player2, runs, p1won, p2won, ties)
  puts "Player 1: " + player1.class.to_s
  puts "Player 2: " + player2.class.to_s
  puts "Player 1 won: " + p1won.to_s
  puts "Player 2 won: " + p2won.to_s
  puts "Ties: " + ties.to_s
  perf = ((p1won.to_f/runs.to_f)*100).round(2)
  puts "Player 2 performance: " + '%' + perf.to_s
  player1.to_s
end

tateti = Tateti.new
eta = 0.1
runs = 1000
learning = Player.new(Tateti::CROSS, eta)
randy = RandomPlayer.new(Tateti::CIRCLE, eta)
dumby = Dummy.new(Tateti::CIRCLE, eta)

train_first(learning, randy, runs)
#train_second(dumby, learning, runs)
#simulate(learning, randy, runs)
#simulate(learning, dumby, runs)