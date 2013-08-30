
require File.join(File.dirname(__FILE__), 'identifier')
require File.join(File.dirname(__FILE__), 'lambda')
require File.join(File.dirname(__FILE__), 'application')


module Sage
  REDUCTION_LIMITS = 100
  CANDIDATE_VARIABLES = ('a'..'zzz').to_a.map(&:intern).freeze

  def self.choose_name(exclusions)
    (CANDIDATE_VARIABLES - exclusions).first
  end

  def self.from_array(array)
    if Symbol === array
      return Identifier.new(array)
    elsif array.first == :lambda
      return Lambda.new(from_array(array[1]),
                        from_array(array[2]))
    else
      return Application.new(from_array(array[0]),
                             from_array(array[1]))
    end
  end

end