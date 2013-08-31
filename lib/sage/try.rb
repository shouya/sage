
require_relative 'parser'
require_relative 'utilities'
require 'ap'


lbd = Sage::SageParser.new.parse('(\x.x x y) (\x.x x y)')




puts lbd.reduce_step.reduce
