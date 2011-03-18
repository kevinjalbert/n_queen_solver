require './chessboard'
require 'set'

class CSPChess < Chessboard 
  def initialize(size)
    super(size)
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

        # Add state only if valid
        if is_valid_state(new_state)
          possible_states << new_state
        end

        bit_state.clear(bit_counter)
      end
      bit_counter += 1
    }

    return possible_states
  end
end
