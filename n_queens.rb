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
An n-queen solver that allows for some flexibility in algorithms.

GitHub: <https://github.com/kevinjalbert/n_queen_solver>

Usage:
        n_queens [options]
where [options] are:
  EOS

  opt :csp, "Use constraint satisfaction problem algorithm", :default => false
  opt :ordered, "Use an ordered search algorithm", :default => false
  opt :queens, "Number of queens", :default => 4
end
Trollop::die :queens, "must be greater then or equal to 4" if opts[:queens] < 4

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
if opts[:dfs]
  @frontier = Containers::Stack.new
else
  @frontier = Containers::Queue.new
end
