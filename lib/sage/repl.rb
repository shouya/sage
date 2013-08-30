

require 'readline'

require File.join(File.dirname(__FILE__), '../sage')
require File.join(File.dirname(__FILE__), 'parser')

module Sage
  class REPL
    attr_accessor :parser, :options
    def initialize
      @parser = SageParser.new
      @options = {
        :reduce  => [:bool, false],  # reduce lambda?
        :step    => [:bool, false],  # show reduction steps?
        :onestep => [:bool, false],  # reduce only one step?
        :limit   => [:int,  100],    # reduce limit
        :textout => [:bool, true]    # text or list output
      }
    end

    def start
      loop do
        status, result = readinput
        case status
        when :eof     then break
        when :empty   then next
        when :set     then set_option(*result); next
        when :let     then define(*result); next
        when :error   then report_syntax_error; next
        when :undef   then undefine(result); next
        when :options then query_options; next
        when :ok      then evaluate(result); next
        end
      end
    end


    def readinput(ps1 = 'sage> ', ps2 = '....> ')
      line = Readline.readline(ps1, true)
      return [:eof, nil] if line.nil?
      (Readline::HISTORY.pop; return [:empty]) if line =~ /^\s*$/
      Readline::HISTORY.pop if Readline::HISTORY.to_a[-2] == line

      if line[/^\:set\s*/]
        option = line.sub(/^\:set\s*/, '').strip
        return [:set, [:on,    option[1..-1]]] if option[0] == '+'
        return [:set, [:off,   option[1..-1]]] if option[0] == '-'
        return [:set, [:set,  *option.strip.split(/\s+/)]]
      end

      return [:options, nil] if line[/^\:options$/]

      if line[/^\:let\s*/]
        name, lamb = *line.sub(/^\:let\s*/).split(/\s/)
        lamb = parse_multiline(lamb, 'let.> ')
        return [:error, nil] if lamb[0] == :error
        return [:let, [name, lamb]]
      end
      return [:undef, line.sub(/^\:undef\s*/).strip] if line[/^\:undef\s*/]

      parse_result = parse_multiline(line, ps2)
      return [:error, nil] if parse_result[0] == :error
      return [:ok, parse_result[1]]
    end

    def parse_multiline(first_line, ps2 = '....> ')
      line = first_line
      tree = nil
      while tree.nil?
        tree = @parser.parse(line)
        if tree.nil? and @parser.failure_index == line.length
          Readline::HISTORY.pop
          line << "\n" << Readline.readline(ps2, false)
          Readline::HISTORY << line
        elsif tree.nil?
          return [:error, nil]
        end
      end

      return [:ok, tree.parse]
    end

    def report_syntax_error
      warn "Syntax Error: " + @parser.failure_reason
      warn "\tfrom (interative):#{@parser.failure_line}:" +
           "#{@parser.failure_column}"
    end

    def set_option(switch, option, value = '')
      option = option.intern
      if not @options.key? option
        warn "Option #{option} not found"
        return
      end

      switch == :on  and @options[option][1] = true  and return
      switch == :off and @options[option][1] = false or  return

      case @options[option][0]
      when :int  then @options[option][1] = value.to_s
      when :bool then @options[option][1] = value.downcase.start_with?('t')
      end
    end

    def define(name, value)
      # todo
    end
    def undefine(name, value)
      # todo
    end
    def query_options
      puts "name\ttype\tvalue"
      @options.each do |k,(t,v)|
        print k
        print "\t"
        print t
        print "\t"
        puts  v
      end
    end

    def evaluate(lambda)
      if !opt(:reduce) and !opt(:onestep)
        puts show_lambda(lambda)
      elsif opt(:onestep)
        puts show_lambda(lambda.reduce_step)
      elsif opt(:reduce)
        puts show_lambda(lambda.reduce(opt(:limit)))
      end
    end

    private
    def opt(name)
      @options[name][1]
    end

    def show_lambda(lambda)
      if opt(:textout)
        lambda.to_s
      else
        lambda.to_array.to_s
      end
    end
  end
end
