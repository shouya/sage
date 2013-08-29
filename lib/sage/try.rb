
require_relative 'parser'
require_relative 'utilities'
require 'ap'


lbd = Sage::Parser.parse('(\x.x x y) (\x.x x y)').parse.tap{|x| puts x.to_s }




puts lbd.reduce_step.reduce_step
