class HumanPlayer < Player

  def play(tateti)
    row = 0
    column = 0
    loop do
      puts "Where do you want to play?"
      print "Insert row: "
      row = gets.to_i
      print "Insert column: "
      column = gets.to_i
      break if tateti.empty_cells.include? [row, column]
      puts "This isnt a correct cell. Try Again"
    end
    tateti.play(row, column, signature)
    tateti
  end
end
