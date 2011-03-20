require './chessboard'
require 'set'

class SimpleChess < Chessboard 
  def initialize(size, random, verbose)
    super(size, random, verbose)
  end

  def get_possible_states
    # No states possible if all queens in play
    if queens_size == @size
      return Array.new
    end

    possible_states = Array.new
    bit_state = @state
    bit_counter = 0

    # Go through each row and locate a state where a queen can be placed
    (@size * @size).times { |cell|
      # Found an empty cell
      if !@state[cell]
        bit_state.set(bit_counter)
        new_state = Bitset.from_s(@state.to_s)

        # Add state
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
