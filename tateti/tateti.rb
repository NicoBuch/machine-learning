class Tateti

  attr_reader :board

  CROSS = 'x';
  CIRCLE = 'o';
  EMPTY = ' ';

  def initialize(new_board = nil)
    return @board = new_board if !new_board.nil?
    @board = []
    3.times { |row| board[row] = [] }
    3.times { |row| 3.times { |column| board[row][column] = EMPTY } }
  end

  def full_board?
    3.times do |row|
      3.times do |column|
        return false if board[row][column] == EMPTY
      end
    end
    true
  end

  def tie?
    full_board? && winner.nil?
  end

  def winner
    3.times do |row|
      next if board[row][0] == EMPTY
      return board[row][0] if board[row][0] == board[row][1] && board[row][1] == board[row][2]
    end
    3.times do |column|
      next if board[0][column] == EMPTY
      return board[0][column] if board[0][column] == board[1][column] && board[1][column] == board[2][column]
    end
    if board[0][0] != EMPTY
      return board[0][0] if board[0][0] == board[1][1] && board[1][1] == board[2][2]
    end
    if board[0][2] != EMPTY
      return board[0][2] if board[0][2] == board[1][1] && board[1][1] == board[2][0]
    end
    nil
  end

  def corners(signature)
    corners = 0
    corners += 1 if board[0][0] == signature
    corners += 1 if board[2][2] == signature
    corners += 1 if board[2][0] == signature
    corners += 1 if board[0][2] == signature
    corners
  end

  def middle(signature)
    return 1 if board[1][1] == signature
    0
  end

  def sides(signature)
    sides = 0
    sides += 1 if board[1][0] == signature
    sides += 1 if board[0][1] == signature
    sides += 1 if board[2][1] == signature
    sides += 1 if board[1][2] == signature
    sides
  end

  def empty_cells
    empty_cells = []
    3.times do |row|
      3.times do |column|
        empty_cells << [row, column] if board[row][column] == EMPTY
      end
    end
    empty_cells
  end

  def play(row, column, signature)
    board[row][column] = signature
  end

  def empty_board
    3.times { |row| 3.times { |column| board[row][column] = EMPTY } }
  end

  def copy_board
    new_board = []
    3.times { |row| new_board[row] = [] }
    3.times do |row|
      3.times do |column|
        new_board[row][column] = board[row][column]
      end
    end
    new_board
  end

  def inminent_lose?(signature)
    3.times do |row|
      return true if inminent_array?(board[row], oponent_signature(signature))
    end
    3.times do |column|
      return true if inminent_array?([board[0][column], board[1][column],
                                     board[2][column]], oponent_signature(signature))
    end
    return true if inminent_array?([board[0][0], board[1][1], board[2][2]],
                                   oponent_signature(signature))

    return true if inminent_array?([board[0][2], board[1][1], board[2][0]],
                                   oponent_signature(signature))

    false
  end

  def oponent_signature(signature)
    return EMPTY if signature == EMPTY
    return CROSS if signature == CIRCLE
    return CIRCLE if signature == CROSS
  end


  def inminent_array?(array, signature)
    array[0] == array[1] && array[0] == signature && array[2] == EMPTY ||
    array[0] == array[2] && array[0] == signature && array[1] == EMPTY ||
    array[2] == array[1] && array[1] == signature && array[0] == EMPTY
  end

  def to_s
    puts ""
    puts ""
    puts "#{board[0][0]} | #{board[0][1]} | #{board[0][2]}"
    puts "----------"
    puts "#{board[1][0]} | #{board[1][1]} | #{board[1][2]}"
    puts "----------"
    puts "#{board[2][0]} | #{board[2][1]} | #{board[2][2]}"
    puts ""
    puts ""
  end
end

