require './chessboard'
require 'set'

class OrderedCSPChess < Chessboard 
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
    row_number = queens_size

    # Find possible locations in the empty row where a queen can be placed
    @size.times { |cell|
      # Found an empty cell
      if !@state[(@size * row_number) + cell]
        bit_state.set((@size * row_number) + cell)
        new_state = Bitset.from_s(@state.to_s)
        # Add state only if valid
        if is_valid_state(new_state)
          possible_states << new_state
        end
        bit_state.clear((@size * row_number) + cell)
      end
    }

    if @random
      possible_states.sort_by! { rand }
    end

    return possible_states
  end
end
