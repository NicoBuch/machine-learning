class RandomPlayer < Player

  def play(tateti)
    possible_plays = tateti.empty_cells
    cell = possible_plays[rand(0..(possible_plays.size - 1))]
    tateti.play(cell[0], cell[1], signature)
    tateti
  end

end
