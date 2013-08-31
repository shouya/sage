
module Sage
  class Application
    attr_accessor :lambda, :applicant

    def initialize(lambda, applicant)
      @lambda = lambda
      @applicant = applicant
    end

    def ==(another)
      return false unless Application === another
      @lambda == another.another and @applicant == another.applicant
    end

    def to_array
      [@lambda.to_array, @applicant.to_array]
    end
    def to_s
      left = @lambda.to_s
      right = @applicant.to_s
      left = "(#{left})" if Lambda === @lambda
      right = "(#{right})" if Application === @applicant or Lambda === @applicant

      "#{left} #{right}"
    end

    def free_variables
      @lambda.free_variables | @applicant.free_variables
    end
    def substitute(a, b)
      return Application.new(@lambda.substitute(a, b),
                             @applicant.substitute(a, b))
    end

    def reduce_step(context)
      lambda = @lambda.reduce_step(context)
      applicant = @applicant.reduce_step(context)
      if Lambda === lambda
        return lambda.apply_step(applicant, context)
      else
        return Application.new(lambda, applicant)
      end
    end
    def reduce(context, limit = REDUCTION_LIMITS)
      lambda = @lambda.reduce(context, limit - 1)
      applicant = @applicant.reduce(context, limit - 1)
      if Lambda === lambda
        lambda = lambda.apply(applicant, context, limit - 1)
      else
        return Application.new(lambda, applicant)
      end
    end
  end
end
