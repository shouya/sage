
module Sage
  class Application
    attr_accessor :lambda, :applicant

    def initialize(lambda, applicant)
      @lambda = lambda
      @applicant = applicant
    end

    def ==(another)
      return false unless Application === another
      @lambda == another.lambda and @applicant == another.applicant
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
      return Application.new(lambda, @applicant) unless lambda == @lambda

      applicant = @applicant.reduce_step(context)
      return Application.new(lambda, applicant) unless applicant == @applicant

      return lambda.apply(applicant, context) if Lambda === lambda

      return Application.new(lambda, applicant)
    end
    def reduce(context, limit = REDUCTION_LIMITS)
      prev = this = self
      limit.times do
        this, prev = this.reduce_step(context), this
        return this if prev == this
      end
      warn 'Reduction limit exceed.'
    end
  end
end
