require './simple_chess'
require './csp_chess'
require './ordered_csp_chess'
require './ordered_simple_chess'
require 'trollop'
require 'algorithms'

# Handle user input with trollop gem
$opts = Trollop::options do
  version "n_queen_solver 0.3 (c) 2011 Kevin Jalbert"
  banner <<-EOS
  An n-queen solver that allows for some flexibility in the approaches for solving.

  GitHub: <https://github.com/kevinjalbert/n_queen_solver>

  Usage:  n_queen_solver [options]

  where [options] are:
  EOS

  opt :csp, "Use constraint satisfaction problem algorithm", :default => false
  opt :dfs, "Use a depth-first search algorithm", :default => false
  opt :ordered, "Use an ordered search algorithm", :default => false
  opt :queens, "Number of queens", :default => 4
  opt :once, "Only find the fist goal state", :default => false
  opt :random, "Randomizes the frontier to allow paths to be explore out of sequence", :default => false
  opt :verbose, "Diplays additional information on the progress of the program", :default => false
end
Trollop::die :queens, "must be a positive number greater then 0" if $opts[:queens] < 1

class NQueenSolver

  def initialize
    create_board
    create_frontier
  end

  def create_board
    # Create specified board
    @board = nil
    if $opts[:csp]
      if $opts[:ordered]
        @board = OrderedCSPChess.new($opts[:queens], $opts[:random], $opts[:verbose])
      else
        @board = CSPChess.new($opts[:queens], $opts[:random], $opts[:verbose])
      end
    else
      if $opts[:ordered]
        @board = OrderedSimpleChess.new($opts[:queens], $opts[:random], $opts[:verbose])
      else
        @board = SimpleChess.new($opts[:queens], $opts[:random], $opts[:verbose])
      end
    end

  end

  def create_frontier
    # Create frontier (stack/queue using algorithms gem)
    @frontier = nil
    if $opts[:dfs]
      @frontier = Containers::Stack.new
      @backtrack = Containers::Stack.new
    else
      @frontier = Containers::Queue.new
      @backtrack = Containers::Queue.new
    end
  end

  def solve
    # Create set to hold distinct goal states
    goal_states = Set.new

    # Create goal timer and state step counter
    initial_time = Time.new
    state_steps = 0

    # Initially populate the frontier and set the backtrack location
    @board.get_possible_states.map { |state|
      @frontier.push(state)
    }
    @backtrack.push(@frontier)

    # Loop till finished (using a backtracking algorithm)
    while true

      if @board.all_valid && @board.queens_size == $opts[:queens]
        if !goal_states.include?(@board.current_state_string)
          goal_states.add(@board.current_state_string)
          print "\nGOAL #{goal_states.size} FOUND (#{@board.current_state_string}) @ step #{state_steps} in #{Time.new - initial_time} seconds\n\n"

          # Exit loop if the once flag was toggled
          if $opts[:once]
            break
          end
        end

        # Backtrack to last state
        @board.backtrack
        @frontier = @backtrack.pop
      end

      # While in an empty state, keep backtracking till a valid state
      while !(@frontier == nil || @frontier.size != 0) #true
        # Backtrack to last state
        @board.backtrack
        @frontier = @backtrack.pop
      end

      # If frontier and backtrack are empty then no more states to explore
      if @frontier == nil && @backtrack.size == 0
        print "\nDONE (Found #{goal_states.size} goal states in #{state_steps} steps and #{Time.new - initial_time} seconds)"
        break
      end

      # Add current state to the backtrack states
      @board.add_backtrack_state

      # Change state to the next state
      @board.change_state(@frontier.pop)

      # Keep track of the states of the board that are valid (all queens in play)
      if @board.queens_size == $opts[:queens]
        state_steps += 1
      end

      # Add the current frontier to the backtrack
      @backtrack.push(@frontier)

      # Get new frontier from current state
      if $opts[:dfs]
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
  end
end

if __FILE__ == $PROGRAM_NAME
  application = NQueenSolver.new
  application.solve
end
