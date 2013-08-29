require 'treetop'

require File.join(File.dirname(__FILE__), 'parser_nodes')

module Sage
  class Parser
    Treetop.load(File.join(File.dirname(__FILE__),
                           'parser.treetop'))
    @@parser = SageParser.new

    def self.parse(data)
      tree = @@parser.parse(data)

      if tree.nil?
        p @@parser
        raise Exception, "Parse error at offset: #{@@parser.index}"
      end

      return tree
    end
  end
end

if __FILE__ == $0
  require 'ap'
  ap Sage::Parser.parse('\m.e b a').parse.to_s
end

