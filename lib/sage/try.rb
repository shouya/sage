
require_relative 'parser'
require_relative 'utilities'
require_relative 'context'
require 'ap'


lbd = Sage::SageParser.new.parse('(\x.x x y) (\x.x x y)').parse
ctx = Sage::Context.new



puts lbd.reduce(ctx)
