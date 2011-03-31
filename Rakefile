begin
  require 'trollop'
  require 'algorithms'
  require 'bitset'
  require 'yard'
rescue LoadError
  abort '### Please ensure the required gems are installed. Try sudo rake gems. ###'
end

require 'rake/clean'
CLEAN.include('./doc')

task :default => :list

task :list do
  system 'rake -T'
end

desc "Installs required gems"
task :gems do
  system "gem install trollop algorithms bitset yard bluecloth"
end

desc "Generate YARD documentation"
task :doc do
  system "yardoc"
end

desc "Runs the program (Ex: rake run['<arguments>'])"
task :run, :args do |t, args|
  puts args.args
  system 'ruby ./lib/n_queen_solver.rb ' + args.args.to_s
end
