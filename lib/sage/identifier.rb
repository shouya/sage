
require File.join(File.dirname(__FILE__), 'expression')


module Sage
  class Identifier < Expression
    def parse
      @name = text_value
      return @name.intern
    end
  end
end

