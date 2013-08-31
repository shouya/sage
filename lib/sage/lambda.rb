
require File.expand_path('utilities', File.dirname(__FILE__))

module Sage
  class Lambda
    attr_accessor :argument, :body

    def initialize(argument, body)
      @argument = argument
      @argument = @argument.name if Identifier === @argument
      @body = body
    end

    # alpha equivalent
    def ==(another)
      return false unless Lambda === another
      return true if @argument == another.argument and @body == another.body
      @body == another.body.substitute(@argument, Identifier.new(@argument))
    end
    def to_array
      [:lambda, @argument, @body.to_array]
    end
    def to_s
      "\\#{@argument.to_s}.#{@body.to_s}"
    end

    def variables
      @body.variables
    end
    def free_variables
      @body.free_variables - [@argument]
    end

    def substitute(a, b)
      if a == @argument or !free_variables.include?(a)
        return self
      end

      unless b.free_variables.include?(@argument)
        return Lambda.new(@argument, @body.substitute(a, b))
      end

      new_arg_name = ::Sage.choose_name(b.free_variables +
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

    def simplify(context, limit = REDUCTION_LIMITS)
      if Lambda === @body
        body = @body.simplify(context, limit)
      else
        body = @body.reduce(context, limit)
      end
      return Lambda.new(@argument, body)
    end

    def apply_step(expr, context)
      @body.substitute(@argument, expr)
      return simplify(context)
    end


    def apply(expr, context, limit = REDUCTION_LIMITS)
      result = @body.substitute(@argument, expr)
      result = result.simplify(context, limit) if Lambda === result

      if limit <= 0
        warn 'step limit exceeded;'
        return result
      end

      if Application === result
        return result.reduce(context, limit - 1)
      end
      result
    end
  end
end
