#!/usr/bin/env ruby
require_relative 'player'
require_relative 'tateti'

tateti = Tateti.new
eta = 0.1
player1 = Player.new(Tateti::CROSS, eta)
player2 = Player.new(Tateti::CIRCLE, eta)

1.times do
  loop do
    tateti = player1.play(tateti, player2)
    break puts 'PLAYER 1 WON' if !tateti.winner.nil?
    break puts 'ITS A TIE' if tateti.tie?
    tateti = player2.play(tateti, player1)
    break puts 'PLAYER 2 WON' if !tateti.winner.nil?
    break puts 'ITS A TIE' if tateti.tie?
  end
  tateti.empty_board
end


puts "side_weight:" + player1.side_weight.to_s
puts "corner_weight:" + player1.corner_weight.to_s
puts "middle_weight:" + player1.middle_weight.to_s
