class Dummy < Player

  def play(board)
    possible_plays = board.empty_cells
    return board if possible_plays[0].nil?
    p = possible_plays[0]
    ans = Tateti.new(board.copy_board)
    ans.play(p[0], p[1], signature)
    return ans
  end

  def update_weights(play, value)
  end

  # Call this method if you want the player to learn
  def play_to_learn(board, opponent)
    return play(board)
  end
end
