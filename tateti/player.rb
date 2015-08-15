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
      won = check_winner(tateti)
      won.nil? ? new_value = game_function(possible_tateti) : new_value = won
      if value.nil? || new_value > value
        best_tateti = possible_tateti
        value = new_value
      end
    end
    best_tateti
  end

  def game_function(tateti)
    side_weight * tateti.sides(signature) +
    corner_weight * tateti.corners(signature) +
    middle_weight * tateti.middle(signature)
  end

  def check_winner(tateti)
    winner = tateti.winner
    return 10 if winner == signature
    return -10 if tateti.inminent_lose?(signature)
    return 0 if tateti.tie?
    nil
  end

  def update_weights(tateti, difference_values)
    @side_weight = side_weight + eta * tateti.sides(signature) * difference_values
    @corner_weight = corner_weight + eta * tateti.corners(signature) * difference_values
    @middle_weight = middle_weight + eta * tateti.middle(signature) * difference_values
  end

end
