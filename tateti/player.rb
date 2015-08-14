class Player
  require 'byebug'

  attr_reader :signature, :side_weight, :corner_weight, :middle_weight, :eta

  def initialize(signature, eta)
    @eta = eta
    @signature = signature
    # These are the Xi, X1 is number of sides, X2 is number of corners and X3 is middle
    @ponds = [1, 2, 3]
    # Aproximations calculated
    @approximation = [0, 0, 0]
    @play_matrix = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  end

  # Call this method if you want the player to learn
  def play_to_learn(tateti, opponent)
    best_play = nil
    value = nil
    tateti.empty_cells.each do |possible_play|
      current_possible = Tateti.new(tateti.copy_board)
      current_possible.play(possible_play[0], possible_play[1], signature)
      current_possible_value = get_leaf_value(current_possible, opponent)
      if value.nil? || current_possible_value > value
        best_play = possible_play
        value = current_possible_value
      end
    end
    update_weights(best_play, @eta)
    tateti.play(best_play[0], best_play[1], signature)
    return tateti
  end

  # Method used to calculate one possible final board and its value only letting players use play method
  def get_leaf_value(tateti, opponent)
    # Assume its turn of the opponent
    loop do
      tateti = opponent.play(tateti)
      break if !tateti.winner.nil?
      break if tateti.tie?
      tateti = play(tateti)
      break if !tateti.winner.nil?
      break if tateti.tie?
    end
    return game_function(tateti)
  end

  # Plays according to what the player have learned
  def play(tateti)
    best_value = nil
    best_play = nil
    tateti.empty_cells.each do |possible_play|
      row = possible_play[0]
      col = possible_play[1]
      current_value = @play_matrix[row][col]
      if best_value.nil? || current_value > best_value
        best_value = current_value
        best_play = possible_play
      end
    end
    tateti.play(best_play[0], best_play[1], signature)
    return tateti
  end

  def game_function(tateti)
    won = check_winner(tateti)
    sides = tateti.sides(signature) * @ponds[0] * @approximation[0]
    corners = tateti.corners(signature) * @ponds[1] * @approximation[1]
    middle = tateti.middle(signature) * @ponds[2] * @approximation[2]
    return (won + sides + corners + middle)
  end

  def check_winner(tateti)
    winner = tateti.winner
    return 0 if winner.nil?
    return 100 if winner == signature
    return -100
  end

  def update_weights(play, value)
    row = play[0]
    col = play[1]
    current = @approximation[row][col]
    @play_matrix[row][col] = current + eta * value
  end

  def to_s
    puts 'Player of class: ' + self.class.to_s
    puts 'Ponderations considered: '
    print 'Sides: ' + @ponds[0].to_s + ' Corners: ' + @ponds[1].to_s + ' Middle: ' + @ponds[2].to_s
    puts 'Aproximations learned: '
    print 'Sides: ' + @approximation[0].to_s + ' Corners: ' + @approximation[1].to_s + ' Middle: ' + @approximation[2].to_s
    puts 'Moves matrix: '
    3.times do |row|
      3.times do |column|
        print @ponds[row][column].round(2)
        print ' | '
      end
      puts ' '
    end
  end
end
