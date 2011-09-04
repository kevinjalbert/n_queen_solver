require 'set'
require 'bitset'
require 'algorithms'

# This class represents the chessboard and contains validating check functions
# along with chessboard state functions. The Chessboard class is a parent class
# of the other specific chessboard classes, which differ only in what the
# possible states are from the current state.
#
# @author Kevin Jalbert
# @version 0.3
class Chessboard

  # Initialize the chessboard of the given size using a Bitset representation
  #
  # To keep track of the possible backtrack states a stack is created. The
  # flags to enable random and verbose are set as well.
  #
  # @note A Bitset structure is used for the chessboard so that the entire
  #   board can be represented in the least amount of memory as possible.
  # @param [Integer] size size of the chessboard also the number of queens
  # @param [Boolean] random indicates if the frontier should be randomize
  # @param [Boolean] verbose indicates if additional detail should be outputted
  def initialize(size, random, verbose)
    @size = size
    @state = Bitset.new(size * size)
    @backtrack_states = Containers::Stack.new
    @random = random
    @verbose = verbose
  end

  # Returns the current state of the chessboard in a chessboard format
  #
  # @return [String] the formated string represents of the current state
  def current_state_string
    string = ""

    (@size * @size).times{ |i|
      if i % @size == 0
        string << "\n\t"
      end
      if @state[i]
        string << "1 "
      else
        string << "0 "
      end
    }
    string << "\n"

    return string
  end

  # Checks to see if the specified column of the chessboard is in a valid state
  #
  # @param [Integer] column the column number to check
  # @return [Boolean] true if the column is valid
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
  protected :valid_column

  # Checks to see if the specified row of the chessboard is in a valid state
  #
  # @param [Integer] row the row number to check
  # @return [Boolean] true if the row is valid
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
  protected :valid_row

  # Checks to see if the specified row of the chessboard is in a valid state
  #
  # The diagonal is checked by using the column location and if the diagonal
  # goes from the top or bottom in the direction left or right. A valid state
  # is where there is 0 or 1 queen present.
  #
  # @param [Boolean] top true if the diagonal is from the top of the chessboard
  # @param [Boolean] right true if the diagonal's direction is to the right
  # @param [Integer] column the column that the diagonal originates from
  # @return [Boolean] true if the diagonal is valid
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
  protected :valid_diagonal

  # Check the entire chessboard and see if it is in a valid state
  #
  # @return [Boolean] true if the chessboard is in a valid state
  def all_valid
    # Check the vertical
    @size.times { |i|
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

    # Check the horizontal
    @size.times { |i|
      if !valid_row(i)
        return false
      end
    }

    return true
  end

  # Checks if the given state would be valid on the chessboard
  #
  # @note The chessboard will temporarily change to the given state to be
  #   validated, which then it is reverted back.
  # @param [Bitset] state the state that will be checked if it is valid
  # @return [Boolean] true if the given state is valid
  def is_valid_state(state)
    temp_state = @state
    @state = temp_state

    if all_valid
      @state = temp_state
      return true
    else
      @state = temp_state
      return false
    end
  end

  # Returns the amount of queens currently on the chessboard
  #
  # @note There is a special situation where a Bitset of 64 bits (8 queens)
  #   will not operate correctly. Thus, there is correctional code to handle
  #   said situation.
  # @todo Remove special correctional code when Bitset fix comes out.
  # @return [Integer] the number of queens currently on the chessboard
  def queens_size
    # Special case to handle a bitset of 64 bits
    if @size == 8
      bits = 0
      (@size * @size).times { |i|
        if @state[i]
          bits += 1
        end
      }
      return bits
    end

    return @state.cardinality
  end

  # Changes the current state of the chessboard to the next state
  #
  # @param [Bitset] next_state the next state to put the chessboard in
  def change_state(next_state)
    @state = next_state
    if @verbose
      puts "\n================================================================================\n\n"
      puts "log: change state to " + current_state_string
    end
  end

  # Adds the current state to the list of backtrack states
  def add_backtrack_state
    if @verbose
      puts "log: add backtrack state"
    end
    state = Bitset.from_s(@state.to_s)
    @backtrack_states.push(state)
  end

  # Changes the current state to that of the last backtrack state
  def backtrack
    @state = @backtrack_states.pop
    if @verbose
      puts "log: backtrack to last valid state"
    end
  end

  # Gets the next set of possible states that comes from the current state
  #
  # @abstract
  # @raise [String] error message about being an abstract function
  def get_possible_states
    raise "This is an abstract function!"
  end
end
