
require File.join(File.dirname(__FILE__), 'expression')

module Sage
  class Lambda < Expression
    def parse
      @argument, @body = elements.values_at(2, 6).map(&:parse)
      return [:lambda, @argument, @body]
    end
  end
end
