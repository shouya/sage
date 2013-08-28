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

#    clean_tree(tree)
    return tree
  end

  private
  def self.clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if do |node|
      node.class.name == "Treetop::Runtime::SyntaxNode"
    end
    root_node.elements.each {|node| self.clean_tree(node) }
  end
end


if __FILE__ == $0
  require 'ap'
  ap Parser.parse('(\m.e b a)x y').parse
end

