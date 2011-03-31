require 'chessboards/chessboard'
require 'set'

# This class inherits from the {Chessboard} class that implements a simple
# algorithm on acquiring the next set of possible states. The algorithm used
# for this chessboard is to consider every state from every free cell in the
# chessboard.
#
# @author Kevin Jalbert
# @version 0.3
class SimpleChess < Chessboard

  # Initializes the simple chessboard using the {Chessboard} parent class
  def initialize(size, random, verbose)
    super(size, random, verbose)
  end

  # Gets the next set of possible states that comes from the current state
  #
  # Every free cell on the chessboard that a queen can be places is considered.
  #
  # @return [Array<Bitset>] an array of Bitset possible states
  def get_possible_states
    if queens_size == @size
      return Array.new
    end

    possible_states = Array.new
    bit_state = @state
    bit_counter = 0

    # Go through each row and locate a state where a queen can be placed
    (@size * @size).times { |cell|
      if !@state[cell]
        bit_state.set(bit_counter)
        new_state = Bitset.from_s(@state.to_s)
        possible_states << new_state
        bit_state.clear(bit_counter)
      end
      bit_counter += 1
    }

    if @random
      possible_states.sort_by! { rand }
    end

    return possible_states
  end
end
