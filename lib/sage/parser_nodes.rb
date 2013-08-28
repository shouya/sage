
module Sage
  class Expression < Treetop::Runtime::SyntaxNode
  end

  class Identifier < Expression
    def parse
      @name = text_value
      return @name.intern
    end
  end

  class Application < Expression
    def parse
      @lambda = elements[0].parse
      @applicants = elements[1].elements.map {|x| x.elements[1].parse }

      applicants_copy = @applicants.dup
      result = [@lambda, applicants_copy.shift]

      until applicants_copy.empty?
        result = [result, applicants_copy.shift]
      end
      return result
    end
  end

  class Lambda < Expression
    def parse
      @argument, @body = elements.values_at(2, 6).map(&:parse)
      return [:lambda, @argument, @body]
    end
  end

  class Parentheses < Expression
    def parse
      return elements[1].parse
    end
  end
end

