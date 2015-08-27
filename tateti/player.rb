class Player
  require 'byebug'

  attr_reader :signature, :side_weight, :corner_weight, :middle_weight,
              :eta, :won, :inminent_lose, :two_in_a_row, :opponent_two_in_a_row

  def initialize(signature, eta)
    @eta = eta
    @signature = signature
    @side_weight, @corner_weight, @middle_weight = 0, 0, 0
    @won, @inminent_lose, @two_in_a_row, @opponent_two_in_a_row = 0, 0, 0, 0
  end

  def play(tateti)
    best_tateti = random_play(Tateti.new(tateti.copy_board))
    value = game_function(best_tateti)
    tateti.empty_cells.each do |possible_play|
      possible_tateti = Tateti.new(tateti.copy_board)
      possible_tateti.play(possible_play[0], possible_play[1], signature)
      new_value = game_function(possible_tateti)
      if new_value > value
        best_tateti = possible_tateti
        value = new_value
      end
      if new_value == value
        if rand < 0.5
          best_tateti = possible_tateti
          value = new_value
        end
      end
    end
    best_tateti
  end

  def game_function(tateti)
    total = 0
    winner = tateti.winner
    total = won if winner == signature
    total += inminent_lose if tateti.inminent_lose?(signature)
    total +
    side_weight * tateti.sides(signature) +
    corner_weight * tateti.corners(signature) +
    middle_weight * tateti.middle(signature) +
    two_in_a_row * tateti.two_in_a_row(signature) +
    opponent_two_in_a_row * tateti.two_in_a_row(tateti.oponent_signature(signature))
  end

  def check_winner(tateti)
    winner = tateti.winner
    return 100 if winner == signature
    return -100 if !winner.nil?
    return 0 if tateti.tie?
    nil
  end

  def update_weights(tateti, difference_values)
    @side_weight = side_weight + eta * tateti.sides(signature) * difference_values
    @corner_weight = corner_weight + eta * tateti.corners(signature) * difference_values
    @middle_weight = middle_weight + eta * tateti.middle(signature) * difference_values
    winner = tateti.winner
    @won = won + eta * difference_values if winner == signature
    @opponent_two_in_a_row = opponent_two_in_a_row + eta * difference_values * tateti.two_in_a_row(tateti.oponent_signature(signature))
    @two_in_a_row = two_in_a_row + eta * difference_values * tateti.two_in_a_row(signature)
    @inminent_lose = inminent_lose + eta * difference_values if tateti.inminent_lose?(signature)
  end


  def random_play(tateti)
    possible_plays = tateti.empty_cells
    cell = possible_plays[rand(0..(possible_plays.size - 1))]
    tateti.play(cell[0], cell[1], signature)
    tateti
  end

  def set_trained_weights
    @side_weight = 2
    @corner_weight = 3
    @middle_weight = 4
    @won = 100
    @inminent_lose = -100
    @two_in_a_row = 5
    @opponent_two_in_a_row = -5
  end

  def set_players_weights(player)
    @side_weight = player.side_weight
    @corner_weight = player.corner_weight
    @middle_weight = player.middle_weight
    @won = player.won
    @inminent_lose = player.inminent_lose
    @two_in_a_row = player.two_in_a_row
    @opponent_two_in_a_row = player.opponent_two_in_a_row
  end

  def to_s
    puts 'Player of class: ' + self.class.to_s
    puts 'Ponderations considered: '
    print 'Sides: ' + @ponds[0].round(2).to_s + ' Corners: ' + @ponds[1].round(2).to_s + ' Middle: ' + @ponds[2].round(2).to_s
    puts ' '
    puts 'Aproximations learned: '
    print 'Sides: ' + @approximation[0].round(2).to_s + ' Corners: ' + @approximation[1].round(2).to_s + ' Middle: ' + @approximation[2].round(2).to_s
    puts ' '
    puts 'Moves matrix: '
    3.times do |row|
      3.times do |column|
        print @play_matrix[row][column].round(2)
        print ' | '
      end
      puts ' '
    end
  end
end
