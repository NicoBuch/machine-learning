#!/usr/bin/env ruby
require_relative 'player'
require_relative 'tateti'
require_relative 'random_player'
require_relative 'human_player'

def train(player1, player2, runs, tateti)
  p1 = 0
  p2 = 0
  ties = 0
  p = 1
  (runs/2).times do |run|
    game_value = training_game_playing_first(player1, player2, tateti, rand < p)
    p1 += 1 if game_value > 0
    ties += 1 if game_value == 0
    p2 += 1 if game_value < 0
    tateti.empty_board
    p -= 1/(runs/2)
  end
  p = 1
  (runs/2).times do |run|
    game_value = training_game_playing_second(player1, player2, tateti, rand < p)
    p1 += 1 if game_value > 0
    ties += 1 if game_value == 0
    p2 += 1 if game_value < 0
    tateti.empty_board
    p -= 1/(runs/2)
  end

  print_stats(p1, p2, ties, player1)
end

def training_game_playing_first(player1, player2, tateti, random)
  random ? tateti = player1.random_play(tateti) : tateti = player1.play(tateti)
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
  final_game_value = training_game_playing_first(player1, player2, tateti, p)
  player1.update_weights(tateti, final_game_value - player1.game_function(tateti))
  return final_game_value
end


def training_game_playing_second(player1, player2, tateti, random)
  player2.play(tateti)
  game_finished = player1.check_winner(tateti)
  unless game_finished.nil?
    player1.update_weights(tateti, game_finished - player1.game_function(tateti))
    return game_finished
  end
  random ? tateti = player1.random_play(tateti) : tateti = player1.play(tateti)
  game_finished = player1.check_winner(tateti)
  unless game_finished.nil?
    player1.update_weights(tateti, game_finished - player1.game_function(tateti))
    return game_finished
  end
  final_game_value = training_game_playing_second(player1, player2, tateti, p)
  player1.update_weights(tateti, final_game_value - player1.game_function(tateti))
  return final_game_value
end

def print_stats(p1, p2, ties, player1)
  puts "PLAYER 1 WON #{p1} games"
  puts "PLAYER 2 WON #{p2} games"
  puts "THERE WERE #{ties} ties"
  puts "FINAL WEIGHTS: "
  puts "side_weight: " + player1.side_weight.to_s
  puts "corner_weight: " + player1.corner_weight.to_s
  puts "middle_weight: " + player1.middle_weight.to_s
  puts "two_in_a_row: " + player1.two_in_a_row.to_s
  puts "oponent_two_in_a_row: " + player1.opponent_two_in_a_row.to_s
  puts "won: " + player1.won.to_s
  puts "inminent_lose: " + player1.inminent_lose.to_s
end


def play_against_human(player1, player2, tateti)
  go_first = true
  loop do
    loop do
      tateti.to_s

      go_first ? tateti = player1.play(tateti) : tateti = player2.play(tateti)
      tateti.to_s
      break puts "#{tateti.winner} WINS!" if !tateti.winner.nil?
      break puts 'ITS A TIE!' if tateti.tie?
      go_first ? tateti = player2.play(tateti) : tateti = player1.play(tateti)
      tateti.to_s
      break puts "#{tateti.winner} !" if !tateti.winner.nil?
      break puts 'ITS A TIE!' if tateti.tie?
    end
    puts 'Do you want to play again? (y/n)'
    answer = gets
    break if answer =~ /n/
    tateti.empty_board
    go_first = !go_first
  end
end

tateti = Tateti.new
eta = 0.01
player1 = Player.new(Tateti::CROSS, eta)
player2 = RandomPlayer.new(Tateti::CIRCLE, eta)
runs = 10000
train(player1, player2, runs, tateti)
player2 = Player.new(Tateti::CIRCLE, eta)
player2.set_players_weights(player1)
train(player1, player2, runs, tateti)
human = HumanPlayer.new(Tateti::CIRCLE, eta)
play_against_human(player1, human, tateti)
