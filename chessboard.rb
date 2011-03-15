require 'set'
require 'bitset'

class Chessboard

  def initialize(size)
    @size = size
    @rows = Array.new(size).map! { |column| 
      Bitset.new(size)
    }
  end

  def print
    puts @rows
  end

  def valid_column(column)
    bits = 0
    @rows.map { |row|
      if row[column]
        bits += 1
      end
      if bits == 2
        return false
      end
    }
    return true
  end

  def valid_row(row)
    bits = 0
    @size.times{ |bit|
      if bit
        bits += 1
      end
      if bits == 2
        return false
      end
    }
    return true
  end

  # bit_string adds from the right
  def change_row(row, bit_string)
    @rows[row] = Bitset.from_s(bit_string)
  end

  def get_possible_states
    raise "This is an abstract method!"
  end
end
