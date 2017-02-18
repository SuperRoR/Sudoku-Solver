class Game
  attr_reader :game_board

  def initialize()
    @game_board = GameBoard.new()
  end

  # Input data

  def load_board(*params)
    @game_board.load_from_array(params)
  end

  # Solve Sudoku using Brute force algorithm

  def solve
    cell_index, cell = @game_board.first
    until cell.nil?
      cell_value = cell.increment
      unless cell_value == false
        if @game_board.value_allowed?(cell_index, cell_value)
          cell.increment!
          cell_index, cell = @game_board.next(cell_index)
        else
          cell.increment!
        end
      else
        cell.empty!
        cell_index, cell = @game_board.prev(cell_index)
      end
    end

    @game_board
  end

end
