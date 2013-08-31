

require File.expand_path('identifier', File.dirname(__FILE__))
require File.expand_path('lambda', File.dirname(__FILE__))
require File.expand_path('application', File.dirname(__FILE__))

module Sage
  class ExpressionNode < Treetop::Runtime::SyntaxNode
    def to_array
      parse.to_array
    end
  end
  class IdentifierNode < ExpressionNode
    def parse
      return Identifier.new text_value.intern
    end
  end

  class ApplicationNode < ExpressionNode
    def parse
      @lambda = elements[0].parse
      @applicants = elements[1].elements.map {|x| x.elements[1].parse }

      applicants_copy = @applicants.dup
      result = Application.new(@lambda, applicants_copy.shift)

      until applicants_copy.empty?
        result = Application.new(result, applicants_copy.shift)
      end
      return result
    end
  end

  class LambdaNode < ExpressionNode
    def parse
      @argument, @body = elements.values_at(2, 6).map(&:parse)
      return Lambda.new(@argument, @body)
    end
  end

  class ParenthesesNode < ExpressionNode
    def parse
      return elements[1].parse
    end
  end
end

