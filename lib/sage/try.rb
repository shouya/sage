
require_relative 'parser'
require_relative 'utilities'
require_relative 'context'
require 'ap'


lbd = Sage::SageParser.new.parse('(\x.x)').parse
#lbd2 = Sage::SageParser.new.parse('(\x.x)').parse
lbd2 = Sage::SageParser.new.parse('(\y.y)').parse
ctx = Sage::Context.new
#ctx.load_builtin_combinators


puts lbd == lbd2


