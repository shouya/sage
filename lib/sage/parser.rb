require 'treetop'

require File.expand_path('parser_nodes', File.dirname(__FILE__))
Treetop.load(File.expand_path('parser.treetop', File.dirname(__FILE__)))

if __FILE__ == $0
  require 'ap'
  ap Sage::SageParser.new.parse('\m.').parse.to_s
end

