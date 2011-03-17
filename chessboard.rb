require 'set'
require 'bitset'
require 'algorithms'

class Chessboard

  def initialize(size)
    @size = size
    @state = Bitset.new(size * size)
    @backtrack_states = Containers::Stack.new
  end

  def print
    puts @state
  end

  def valid_column(column)
    bits = 0

    @size.times { |i|
      if @state[(@size *i) + column]
        bits += 1
        if bits > 1
          return false
        end
      end
    }

    return true
  end

  def valid_row(row)
    row_begin = @size * (row)
    bits = 0

    @size.times { |i|
      if @state[row_begin + i]
        bits += 1
        if bits > 1 
          return false
        end
      end
    }

    return true
  end

  # top if true means we are dealing with top row locations
  # right if true means we are dealing with diagonal movement to the right
  # n is the column|row position starting from the top left of the board
  def valid_diagonal(top, right, n)
    bits = 0
    if top
      if right
        (@size - n).times { |i|
          if @state[((@size + 1) * i) + n]
            bits += 1
          end
        }
      else
        (n + 1).times { |i|
          if @state[((@size - 1) * i) + n]
            bits += 1
          end
        }
      end
    else
      n_pos = n + ((@size - 1) * @size)
      if right
        (@size - n).times { |i|
          if @state[n_pos - ((@size - 1) * i)]
            bits += 1
          end
        }
      else
        (n + 1).times { |i|
          if @state[n_pos - ((@size + 1) * i)]
            bits += 1
          end
        }
      end
    end

    if bits > 1
      return false
    else
      return true
    end
  end

  def all_valid
    # Check the vertical and horizontal
    @size.times { |i|
      if !valid_row(i)
        return false
      end
      if !valid_column(i)
        return false
      end
    }

    # Check the diagonal
    @size.times { |i|
      if !valid_diagonal(true, true, i)
        return false
      end
      if !valid_diagonal(true, false, i)
        return false
      end
      if !valid_diagonal(false, true, i)
        return false
      end
      if !valid_diagonal(false, false, i)
        return false
      end
    }

    return true
  end

  def is_valid_state(state)
    # Temporarily change state
    temp_state = @state
    @state = temp_state

    # Check if state is valid
    if all_valid
      @state = temp_state
      return true
    else
      @state = temp_state
      return false
    end
  end

  def queens_size
    return @state.cardinality
  end

  def change_state(next_state)
    # puts "  change state to " + next_state.to_s
    @state = next_state
  end

  def add_backtrack_state
    #puts "  add backtrack state " + @state.to_s
    state = Bitset.from_s(@state.to_s)
    @backtrack_states.push(state)
  end

  def backtrack
    #puts "  backtrack from " + @state.to_s
    @state = @backtrack_states.pop
    #puts "  to " + @state.to_s
  end

  def get_possible_states
    raise "This is an abstract method!"
  end
end
