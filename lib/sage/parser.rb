require 'treetop'

require_relative 'parser_nodes'
Treetop.load(File.expand_path('parser.treetop', File.dirname(__FILE__)))

# debug:
#require_relative 'my_parser'

class Sage::SageParser
  alias_method :__parse, :parse
end

if __FILE__ == $0
  require 'ap'
  puts Sage::SageParser.new.parse('a a a', :root => :paired_expression).parse
end

