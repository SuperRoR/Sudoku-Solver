# Class implements methods for easier manipulation with sudoku board

class GameBoard
  attr_reader :rows
  attr_reader :size
  attr_reader :sub_size

  def initialize(*params)
    @size = 0
    @sub_size = 0
    params.empty? ? (@rows = Array.new) : load_from_array(params)
  end

  # Override == operation for comparing objects

  def ==(o)
    self.to_a == o.to_a
  end

  # Indicate specific cell

  def cell_at(cell_index)
    @rows[cell_index / @size.to_i][cell_index % @size.to_i]
  end

  # Initialize from Array

  def load_from_array(array)
    @rows = Array.new
    formated_array = array.each_slice(9).to_a

    formated_array.each do |each_line|
      @rows.push(
          each_line.collect do |value|
            value = value.to_i
            if value > 0
              Cell.new(value, 9, true)
            else
              Cell.new(nil, 9)
            end
          end
      )
    end

    @size = @rows.count
    @sub_size = Math.sqrt(@size)
  end

  # Return first blank cell and index

  def first
    (0..(@size*@size-1)).each do |index|
      return index, cell_at(index) unless cell_at(index).predefined?
    end
    nil
  end

  # Return next blank cell and index

  def next(cell_index)
    (cell_index+1..(@size*@size-1)).each do |index|
      return index, cell_at(index) unless cell_at(index).predefined?
    end
    return nil, nil
  end

  # Return previous blank cell and index

  def prev(cell_index)
    (0..cell_index-1).reverse_each do |index|
      return index, cell_at(index) unless cell_at(index).predefined?
    end
    return nil, nil
  end

  # Check if the value can be placed at that cell

  def value_allowed?(cell_index, value)
    row_index = cell_index / @size.to_i
    column_index = cell_index % @size.to_i
    return false if row_contains_value?(row_index, value)
    return false if column_contains_value?(column_index, value)
    return false if subsection_contains_value?(row_index, column_index, value)
    true
  end

  # Check if row(row_index) contains <value>

  def row_contains_value?(row_index, value)
    (0..@size-1).each do |column_index|
      return true if @rows[row_index][column_index].value == value
    end
    false
  end

  # Check if column(column_index) contains <value>

  def column_contains_value?(column_index, value)
    (0..@size-1).each do |row_index|
      return true if @rows[row_index][column_index].value == value
    end
    false
  end

  # Check if 3*3 subsection contains the <value>

  def subsection_contains_value?(row_index, column_index, value)
    start_row_index = row_index - (row_index % @sub_size)
    start_column_index = column_index - (column_index % @sub_size)
    end_row_index = start_row_index + @sub_size - 1
    end_column_index = start_column_index + @sub_size - 1
    @rows[start_row_index..end_row_index].each do |row|
      row[start_column_index..end_column_index].each do |cell|
        return true if cell.value == value
      end
    end
    false
  end

  # Format to String

  def to_s
    output = ''
    @rows.each do |row|
      output += row.collect { |column| column.to_s }.join(' ') + "\n"
    end
    output
  end

  # Format to Array

  def to_a
    output = Array.new
    @rows.each do |row|
      output.push row.collect { |column| column.to_s }
    end
    output
  end

  # Class represents one cell in sudoku gameboard

  class Cell
    attr_accessor :value
    attr_reader :predefined

    def initialize(value, max_value = 9, predefined = false)
      @max_value = max_value
      @value = value
      @predefined = predefined
    end

    def predefined?
      @predefined
    end

    def empty?
      @value.nil? ? true : false
    end

    def empty!
      @value = nil
    end

    def to_s
      empty? ? '?' : @value.to_s
    end

    def increment
      if empty?
        1
      else
        if @value == @max_value
          false
        else
          @value.next
        end
      end
    end

    def increment!
      @value = self.increment
    end
  end

end
