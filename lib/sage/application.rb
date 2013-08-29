
module Sage
  class Application
    attr_accessor :lambda, :applicant

    def initialize(lambda, applicant)
      @lambda = lambda
      @applicant = applicant
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

    def reduce_step
      lambda = @lambda.reduce_step
      applicant = @applicant.reduce_step
      if Lambda === lambda
        return lambda.apply_step(applicant)
      else
        return self
      end
    end
    def reduce(limit = REDUCTION_LIMITS)
      lambda = @lambda.reduce(limit - 1)
      applicant = @applicant.reduce(limit - 1)
      if Lambda === lambda
        return lambda.apply(applicant, limit - 1)
      else
        return self
      end
    end
  end
end
