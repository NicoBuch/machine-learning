class Player
  require 'byebug'

  attr_reader :signature, :side_weight, :corner_weight, :middle_weight, :eta

  def initialize(signature, eta)
    @eta = eta
    @signature = signature
    @side_weight = 1
    @corner_weight = 1
    @middle_weight = 1
  end

  def play(tateti)
    best_tateti = tateti
    value = nil
    tateti.empty_cells.each do |possible_play|
      possible_tateti = Tateti.new(tateti.copy_board)
      possible_tateti.play(possible_play[0], possible_play[1], signature)
      won = check_winner(possible_tateti)
      return possible_tateti if won != nil && won > 0
      new_value = game_function(possible_tateti)
      if value.nil? || new_value > value
        best_tateti = possible_tateti
        value = new_value
      end
      if new_value == value
        if rand(0..1) == 0
          best_tateti = possible_tateti
          value = new_value
        end
      end
    end
    best_tateti
  end

  def game_function(tateti)
    return -1 if tateti.inminent_lose?(signature)
    side_weight * tateti.sides(signature) +
    corner_weight * tateti.corners(signature) +
    middle_weight * tateti.middle(signature)
  end

  def check_winner(tateti)
    winner = tateti.winner
    return 10 if winner == signature
    return -10 if !winner.nil?
    return 0 if tateti.tie?
    nil
  end

  def update_weights(tateti, difference_values)
    @side_weight = side_weight + eta * tateti.sides(signature) * difference_values
    @corner_weight = corner_weight + eta * tateti.corners(signature) * difference_values
    @middle_weight = middle_weight + eta * tateti.middle(signature) * difference_values
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
  end

end
