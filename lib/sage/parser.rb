require 'treetop'

require File.expand_path(File.dirname(__FILE__), 'parser_nodes')

class Parser
  Treetop.load(File.expand_path(File.dirname(__FILE__),
                                'parser.treetop'))
  @@parser = SageParser.new

  def self.parse(data)
    tree = @@parser.parse(data)
    @@parser.root = :program

    if tree.nil?
      p @@parser
      raise Exception, "Parse error at offset: #{@@parser.index}"
    end

    return tree
  end
end


if __FILE__ == $0
  p Parser.parse('(\m.e b a)x y').parse
end

