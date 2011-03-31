require './simple_chess'
require './csp_chess'
require './ordered_csp_chess'
require './ordered_simple_chess'
require 'trollop'
require 'algorithms'

# This class parses the user's input for the parameters they wish to use. The
# initialization of the chessboard is accomplished along with the frontier.
# The algorithm to solve the problem is also implemented in this class.
#
# @author Kevin Jalbert
# @version 0.3
class NQueenSolver

  # Handles the inputted user parameters and creates the chessboard
  def initialize
    @opts = Trollop::options do
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
    Trollop::die :queens, "must be a positive number greater then 0" if @opts[:queens] < 1

    create_board
    create_frontier
  end

  # Creates the correct chessboard based on the user parameters
  #
  # There are four possible chessboard, which only differ in their
  # ability to find possible states.
  def create_board
    @board = nil
    if @opts[:csp]
      if @opts[:ordered]
        @board = OrderedCSPChess.new(@opts[:queens], @opts[:random], @opts[:verbose])
      else
        @board = CSPChess.new(@opts[:queens], @opts[:random], @opts[:verbose])
      end
    else
      if @opts[:ordered]
        @board = OrderedSimpleChess.new(@opts[:queens], @opts[:random], @opts[:verbose])
      else
        @board = SimpleChess.new(@opts[:queens], @opts[:random], @opts[:verbose])
      end
    end
  end
  private :create_board

  # Creates the frontier and backtracking structures
  #
  # Backtrack structure is a queue or stack based on the user parameter.
  def create_frontier
    @frontier = Array.new
    if @opts[:dfs]
      @backtrack = Containers::Stack.new
    else
      @backtrack = Containers::Queue.new
    end
  end
  private :create_frontier

  # Solves the n-queen problem after the chessboard and frontier are set
  #
  # The algorithm to solve the n-queen problem is a standard backtracking
  # algorithm that keeps track of the current frontier. This approach will
  # explore all states of the chessboard while notifying about goal states.
  def solve
    goal_states = Set.new  # Holds the distinct goal states

    initial_time = Time.new
    state_steps = 0

    # Initially populate the frontier and set the current backtrack location
    @board.get_possible_states.map { |state|
      @frontier.push(state)
    }
    @backtrack.push(@frontier)

    # Loop till finished (end conditions are first goal state if the --once is
    # true, or all states have been explored) using a backtracking approach
    while true

      # Check if the current board is in a goal state
      if @board.all_valid && @board.queens_size == @opts[:queens]
        if !goal_states.include?(@board.current_state_string)
          goal_states.add(@board.current_state_string)
          print "\nGOAL #{goal_states.size} FOUND (#{@board.current_state_string}) @ step #{state_steps} in #{Time.new - initial_time} seconds\n\n"

          if @opts[:once]
            break
          end
        end
        @board.backtrack
        @frontier = @backtrack.pop
      end

      # While in an empty state, keep backtracking till a valid state
      while !(@frontier == nil || @frontier.size != 0)
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
      state_steps += 1

      # Add the current frontier to the backtrack
      @backtrack.push(@frontier)

      # Get new frontier from current state
      @frontier = Array.new
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

# If this is the main file, run the solver
if __FILE__ == $PROGRAM_NAME
  application = NQueenSolver.new
  application.solve
end
