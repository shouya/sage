
require File.join(File.dirname(__FILE__), 'expression')

module Sage
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

  class SubApplication < Expression
    def parse
#      p '-----------'
#      p elements[1]
      elements[1].parse if Application === elements[1]
      return elements[1].parse
    end
  end
end

