
module Sage
  class Parentheses < Treetop::Runtime::SyntaxNode
    def parse
      return elements[1].parse
    end
  end
end

require File.join(File.dirname(__FILE__), 'identifier')
require File.join(File.dirname(__FILE__), 'lambda')
require File.join(File.dirname(__FILE__), 'application')

