require './chessboard'
require 'set'

class OrderedSimpleChess < Chessboard 
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
    row_number = queens_size

    # Find possible locations in the empty row where a queen can be placed
    @size.times { |cell|
      # Found an empty cell
      if !@state[(@size * row_number) + cell]
        bit_state.set((@size * row_number) + cell)
        new_state = Bitset.from_s(@state.to_s)

        # Add state
        possible_states << new_state

        bit_state.clear((@size * row_number) + cell)
      end
    }

    return possible_states
  end
end
