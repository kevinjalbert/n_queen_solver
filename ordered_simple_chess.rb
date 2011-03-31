require './chessboard'
require 'set'

# This class inherits from the {Chessboard} class that implements an ordered
# algorithm on acquiring the next set of possible states. The algorithm used
# for this chessboard is to consider only the valid states from any free cell
# on the chessboard that a queen can be placed.
#
# @author Kevin Jalbert
# @version 0.3
class OrderedSimpleChess < Chessboard

  # Initializes the ordered chessboard using the {Chessboard} parent class
  def initialize(size, random, verbose)
    super(size, random, verbose)
  end

  # Gets the next set of possible states that comes from the current state
  #
  # Every free cell from the next row that a queen can be placed on in the
  # chessboard is considered.
  #
  # @return [Array<Bitset>] an array of Bitset possible states
  def get_possible_states
    if queens_size == @size
      return Array.new
    end

    possible_states = Array.new
    bit_state = @state
    row_number = queens_size

    # Find possible locations in the empty row where a queen can be placed
    @size.times { |cell|
      if !@state[(@size * row_number) + cell]
        bit_state.set((@size * row_number) + cell)
        new_state = Bitset.from_s(@state.to_s)
        possible_states << new_state
        bit_state.clear((@size * row_number) + cell)
      end
    }

    if @random
      possible_states.sort_by! { rand }
    end

    return possible_states
  end
end
