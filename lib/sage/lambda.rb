
require File.join(File.dirname(__FILE__), 'utilities')

module Sage
  class Lambda
    attr_accessor :argument, :body

    def initialize(argument, body)
      @argument = argument
      @body = body
    end

    def to_array
      [:lambda, @argument.to_array, @body.to_array]
    end
    def to_s
      "\\#{@argument.name.to_s}.#{@body.to_s}"
    end

    def variables
      @body.variables
    end
    def free_variables
      @body.free_variables - [@argument.name]
    end

    def substitute(a, b)
      arg_name = @argument.name
      if a == arg_name or !free_variables.include?(a)
        return self
      end

      unless b.free_variables.include?(arg_name)
        return Lambda.new(@argument, @body.substitute(a, b))
      end

      new_arg_name = Sage.choose_name(b.free_variables +
                                      @body.free_variables)
      new_body = @body.substitute(@argument.name,
                                  Identifier.new(new_arg_name))

      return Lambda.new(Identifier.new(new_arg_name),
                        new_body.substitute(a, b))
    end

    def reduce(*)
      self
    end
    alias_method :reduce_step, :reduce

    def apply_step(expr)
      @body.substitute(@argument.name, expr)
    end
    def apply(expr, limits = REDUCTION_LIMITS)
      result = apply_step(expr)
      if limits <= 0
        warn 'step limit exceeded;'
        return result
      end

      if Application === result
        return result.reduce(limits - 1)
      end
    end
  end
end
