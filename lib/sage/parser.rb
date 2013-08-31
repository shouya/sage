require 'treetop'

require File.expand_path('parser_nodes', File.dirname(__FILE__))
Treetop.load(File.expand_path('parser.treetop', File.dirname(__FILE__)))

# debug:
#require File.expand_path('my_parser', File.dirname(__FILE__))

class Sage::SageParser
  alias_method :__parse, :parse
end

if __FILE__ == $0
  require 'ap'
  puts Sage::SageParser.new.parse('a a a', :root => :paired_expression).parse
end

