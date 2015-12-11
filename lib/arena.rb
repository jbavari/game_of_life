# :nodoc:
class Arena
  attr_reader :playing_field, :width, :height
  def initialize(row_length = 100, column_length = 100)
    @width = column_length
    @height = row_length
    @playing_field = Array.new(@width) { Array.new(@height, false) }
  end

  def set_status(x, y, life_status)
    @playing_field[x][y] = life_status
  end

  def status(x, y)
    @playing_field[x][y]
  end

  def row_out_of_bounds(x, y)
    row_bounds = x < 0 || x >= @height - 1
    col_bounds = y < 0 || y >= @width - 1
    row_bounds || col_bounds
  end

  def check_status(row, column)
    neighbor_count = 0
    ((row - 1)..(row + 1)).each do |row_index|
      ((column - 1)..(column + 1)).each do |col_index|
        # Continue on if its out of bounds or is the cell we're currently on
        is_same_cell = row_index == row && col_index == column
        out_of_bounds = row_out_of_bounds(row_index, col_index)
        next if out_of_bounds || is_same_cell
        neighbor_count += 1 if status(row_index, col_index)
      end
    end
    neighbor_count
  end

  def print_game
    @playing_field.each_with_index do |_row, index|
      row.each_with_index do |_column, column_index|
        life_indicator = @playing_field[index][column_index] ? 'O' : 'X'
        print life_indicator
      end
      puts ''
    end
  end

  def decide_life(cell_status, neighbor_count)
    if cell_status && neighbor_count > 3
      return false
    elsif cell_status && neighbor_count < 2
      return false
    elsif cell_status && (neighbor_count == 2 || neighbor_count == 3)
      return true
    elsif cell_status == false && neighbor_count == 3
      return true
    end
  end

  # Any live cell with fewer than two live neighbours dies,
  # as if caused by underpopulation.
  # Any live cell with more than three live neighbours dies,
  # as if by overcrowding.
  # Any live cell with two or three live neighbours lives on
  # to the next generation.
  # Any dead cell with exactly three live neighbours
  # becomes a live cell.
  def next_day
    @next_field = Array.new(@width) { Array.new(@height, false) }

    @playing_field.each_with_index do |row, row_index|
      row.each_with_index do |_column, col_index|
        neighbor_count = check_status(row_index, col_index)
        cell_status = @playing_field[row_index][col_index]
        new_cell_status = decide_life(cell_status, neighbor_count)
        @next_field[row_index][col_index] = new_cell_status
      end
    end

    @playing_field = @next_field
  end # next
end
