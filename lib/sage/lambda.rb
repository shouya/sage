
require File.expand_path('utilities', File.dirname(__FILE__))
require File.expand_path('context', File.dirname(__FILE__))

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


    def simplest?(context = Context.new)
      return simplify(context) == self
    end
    def simplify_step(context)
#      if Lambda === @body
#        body = @body.simplify_step(context)
#      else
#        body = @body.reduce_step(context)
#      end
      return Lambda.new(@argument, @body.reduce_step(context))
    end
    alias_method :reduce_step, :simplify_step

    def reduce(context, limit = REDUCTION_LIMITS)
      prev = this = nil
      limit.times do
        prev, this = this, reduce_step(context)
        return this if prev == prev
      end
      warn 'reduce limit exceed.'
    end
    alias_method :simplify, :reduce

    def apply(expr, context)
      return @body.substitute(@argument, expr)
    end

  end
end
