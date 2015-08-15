#!/usr/bin/env ruby
require_relative 'player'
require_relative 'tateti'
require_relative 'random_player'

def train(player1, player2, runs, tateti)
  p1 = 0
  p2 = 0
  ties = 0
  10000.times do
    game_value = training_game(player1, player2, tateti)
    p1 += 1 if game_value > 0
    ties += 1 if game_value == 0
    p2 += 1 if game_value < 0
    tateti.empty_board
  end
  print_stats(p1, p2, ties, player1)
end

def training_game(player1, player2, tateti)
  tateti = player1.play(tateti)
  game_finished = player1.check_winner(tateti)
  unless game_finished.nil?
    player1.update_weights(tateti, game_finished - player1.game_function(tateti))
    return game_finished
  end
  tateti = player2.play(tateti)
  game_finished = player1.check_winner(tateti)
  unless game_finished.nil?
    player1.update_weights(tateti, game_finished - player1.game_function(tateti))
    return game_finished
  end
  final_game_value = training_game(player1, player2, tateti)
  player1.update_weights(tateti, final_game_value - player1.game_function(tateti))
  return final_game_value
end

def print_stats(p1, p2, ties, player1)
  puts "PLAYER 1 WON #{p1} games"
  puts "PLAYER 2 WON #{p2} games"
  puts "THERE WERE #{ties} ties"
  puts "FINAL WEIGHTS:"
  puts "side_weight:" + player1.side_weight.to_s
  puts "corner_weight:" + player1.corner_weight.to_s
  puts "middle_weight:" + player1.middle_weight.to_s
end


tateti = Tateti.new
eta = 0.01
player1 = Player.new(Tateti::CROSS, eta)
player2 = RandomPlayer.new(Tateti::CIRCLE, eta)
runs = 1000
train(player1, player2, runs, tateti)
play_to_player
