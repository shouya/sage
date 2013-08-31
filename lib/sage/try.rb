
require_relative 'parser'
require_relative 'utilities'
require_relative 'context'
require 'ap'


lbd = Sage::SageParser.new.parse('succ one').parse
ctx = Sage::Context.new
ctx.load_builtin_combinators


puts lbd.reduce(ctx).to_s


