
require_relative 'parser'
require_relative 'utilities'
require_relative 'context'
require 'ap'


lbd = Sage::SageParser.new.parse('plus three one').parse
ctx = Sage::Context.new
ctx.load_builtin_combinators


20.times do
  puts lbd.to_s
  lbd = lbd.reduce_step(ctx)
end
puts lbd
