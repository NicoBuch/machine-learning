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

  def play(tateti, opponent)
    best_tateti = tateti
    value = 0
    tateti.empty_cells.each do |possible_play|
      possible_tateti = Tateti.new(tateti.copy_board)
      possible_tateti.play(possible_play[0], possible_play[1], signature)

      loop do
        possible_tateti = opponent.play(possible_tateti, self)
        break if !possible_tateti.winner.nil?
        break if possible_tateti.tie?
        possible_tateti = play(possible_tateti, opponent)
        break if !possible_tateti.winner.nil?
        break if possible_tateti.tie?
      end

      new_value = game_function(possible_tateti)
      if value == 0 || new_value > value
        best_tateti = Tateti.new(tateti.copy_board)
        best_tateti.play(possible_play[0], possible_play[1], signature)
        value = new_value
      end
    end
    update_weights(best_tateti, value - game_function(tateti))
    best_tateti
  end

  def game_function(tateti)
    won = check_winner(tateti)
    return won unless won.nil?
    side_weight * tateti.sides(signature) +
    corner_weight * tateti.corners(signature) +
    middle_weight * tateti.middle(signature)
  end

  def check_winner(tateti)
    winner = tateti.winner
    return 100 if winner == signature
    return -100 if tateti.inminent_lose?(signature)
    return -10 if tateti.tie?
    0
  end

  def update_weights(tateti, difference_values)
    @side_weight = side_weight + eta * tateti.sides(signature) * difference_values
    @corner_weight = corner_weight + eta * tateti.corners(signature) * difference_values
    @middle_weight = middle_weight + eta * tateti.middle(signature) * difference_values
  end

end
