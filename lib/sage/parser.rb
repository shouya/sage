require 'treetop'

require File.join(File.dirname(__FILE__), 'parser_nodes')
Treetop.load(File.join(File.dirname(__FILE__), 'parser.treetop'))

if __FILE__ == $0
  require 'ap'
  ap Sage::Parser.parse('\m.').parse.to_s
end

