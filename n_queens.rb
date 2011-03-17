require './simple_chess'
require './csp_chess'
require './ordered_csp_chess'
require './ordered_simple_chess'
require 'trollop'
require 'algorithms'

# Handle user input with trollop gem
opts = Trollop::options do
  version "n_queen_solver 0.1 (c) 2011 Kevin Jalbert"
  banner <<-EOS
  An n-queen solver that allows for some flexibility in the approaches for solving.

  GitHub: <https://github.com/kevinjalbert/n_queen_solver>

  Usage:  n_queens [options]

  where [options] are:
  EOS

  opt :csp, "Use constraint satisfaction problem algorithm", :default => false
  opt :dfs, "Use a depth-first search algorithm", :default => false
  opt :ordered, "Use an ordered search algorithm", :default => false
  opt :queens, "Number of queens", :default => 4
  opt :once, "Only find the fist goal state", :default => false
end
Trollop::die :queens, "must be a positive number greater then 0" if opts[:queens] < 1

# Create specified board
@board = nil
if opts[:csp]
  if opts[:ordered]
    @board = OrderedCSPChess.new(opts[:queens])
  else
    @board = CSPChess.new(opts[:queens])
  end
else
  if opts[:ordered]
    @board = OrderedSimpleChess.new(opts[:queens])
  else
    @board = SimpleChess.new(opts[:queens])
  end
end

# Create frontier (stack/queue using algorithms gem)
@frontier = nil
@backtrack = Containers::Stack.new
if opts[:dfs]
  @frontier = Containers::Stack.new
else
  @frontier = Containers::Queue.new
end

# Initially populate the frontier and set the backtrack location
@board.get_possible_states.map { |state|
  @frontier.push(state)
}
@backtrack.push(@frontier)

# Loop till finished (using a backtracking algorithm)
while true
  # Check for goal state
  if @board.all_valid && @board.queens_size == opts[:queens]
    puts "==GOAL=="
    @board.print

    # Exit loop if the once flag was toggled
    if opts[:once]
      break
    end

    # Backtrack to last state
    @board.backtrack
    @frontier = @backtrack.pop
  end

  # While in an empty state, keep backtracking till a valid state
  while true
    # Frontier has states, or does not have anything left anymore
    if @frontier == nil || @frontier.size != 0
      break
    end

    # Backtrack to last state
    @board.backtrack
    @frontier = @backtrack.pop
  end

  # If frontier is empty then no more states to explore
  if @frontier == nil
    puts "==DONE=="
    break
  end

  # Add current state to the backtrack states
  @board.add_backtrack_state

  # Change state to the next state
  @board.change_state(@frontier.pop)

  # Add the current frontier to the backtrack
  @backtrack.push(@frontier)

  # Get new frontier from current state
  if opts[:dfs]
    @frontier = Containers::Stack.new
  else
    @frontier = Containers::Queue.new
  end
  @board.get_possible_states.map { |state|
    @frontier.push(state)
  }

  # Push frontier on backtrack if states are present in frontier
  if @frontier.size != 0
    @backtrack.push(@frontier)
  end
end
