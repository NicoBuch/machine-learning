class RandomPlayer < Player

  def play(tateti)
    possible_plays = tateti.empty_cells
    cell = possible_plays[rand(0..(possible_plays.size - 1))]
    possible_tateti = Tateti.new(tateti.copy_board)
    possible_tateti.play(cell[0], cell[1], signature)
    possible_tateti
  end

end
