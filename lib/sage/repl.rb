

require 'readline'

require_relative '../sage'
require_relative 'parser'

module Sage
  class REPL
    attr_accessor :parser, :options

    def initialize
      @parser = SageParser.new
      @context = Context.new
      @options = {
        :reduce  => [:bool, true],    # reduce lambda?
        :step    => [:bool, true],    # show reduction steps?
        :onestep => [:bool, false],   # reduce only one step?
        :limit   => [:int,  100],     # reduce limit
        :textout => [:bool, true],    # text or list output
        :parseresult => [:bool, true]
      }

      @context.load_builtin_combinators(@parser)
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
        when :eqv     then beta_eqv(*result); next
        end
      end
    end


    def readinput(ps1 = 'sage> ', ps2 = '....> ')
      line = Readline.readline(ps1, true)
      return [:eof, nil] if line.nil?
      (Readline::HISTORY.pop; return [:empty]) if line =~ /^\s*$/
      Readline::HISTORY.pop if Readline::HISTORY.to_a[-2] == line

      return [:eof, nil] if %w[:quit :exit :q].include?(line.strip)

      if line[/^\:set\s*/]
        option = line.sub(/^\:set\s*/, '').strip
        return [:set, [:on,    option[1..-1]]] if option[0] == '+'
        return [:set, [:off,   option[1..-1]]] if option[0] == '-'
        return [:set, [:set,  *option.strip.split(/\s+/, 2)]]
      end

      return [:options, nil] if line[/^\:options$/]

      if line[/^\:let\s*/]
        name, lamb = *line.sub(/^\:let\s*/, '').split(/\s+/, 2)
        lamb = parse_multiline(lamb, 'let.> ')
        # todo: readline history fix
        return [:error, nil] if lamb[0] == :error
        return [:let, [name, lamb[1]]]
      end
      return [:undef, line.sub(/^\:undef\s*/, '').strip] if line[/^\:undef\s*/]

      if line[/^:eqv/]
        lamb = line.sub(/^\:eqv\s*/, '')
        result = parse_multiline(lamb, 'eqv.> ', :root => :paired_expression)
        # todo: readline history fix
        return [:error, nil] if result[0] == :error
        return [:eqv, result[1]]
      end

      parse_result = parse_multiline(line, ps2)
      return [:error, nil] if parse_result[0] == :error
      return [:ok, parse_result[1]]
    end

    def parse_multiline(first_line, ps2 = '....> ', options = {})
      line = first_line
      tree = nil
      while tree.nil?
        tree = @parser.parse(line, options)
        if tree.nil? and @parser.failure_index == line.length
          Readline::HISTORY.pop
          line << "\n" << Readline.readline(ps2, false)
          Readline::HISTORY << line
        elsif tree.nil?
          return [:error, nil]
        end
      end

      return [:ok, tree.map(&:parse)] if Array === tree
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

      switch == :on  and (@options[option][1] = true  and return)
      switch == :off and (@options[option][1] = false or  return)

      case @options[option][0]
      when :int  then @options[option][1] = value.to_i
      when :bool then @options[option][1] = value.downcase.start_with?('t')
      end
    end

    def define(name, value)
      @context[name.intern] = eval_lambda(value)
    end
    def undefine(name)
      @context.delete(name.intern)
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
      if opt(:reduce) and not opt(:onestep) and opt(:step)
        this = prev = lambda
        1.upto(opt(:limit)) do |n|
          this, prev = this.reduce_step(@context), this
          puts "#{n}: #{show_lambda(prev)}"

          this == prev and return output(this)
        end
        puts "Reduction limit exceeded."
      else
        output(eval_lambda(lambda))
      end
    end

    def beta_eqv(a, b)
      result = a.reduce(@context) == b.reduce(@context)
      puts result
    end

    private
    def opt(name)
      @options[name][1]
    end

    def parse_result(result)
      opt(:parseresult) and @context.each do |k,v|
        return k.to_s if result == v
      end
      false
    end

    def show_lambda(lambda)
      if opt(:textout)
        lambda.to_s
      else
        lambda.to_array.to_s
      end
    end

    def eval_lambda(lambda)
      if !opt(:reduce)
        lambda = lambda.reduce_step(@context) if Identifier === lambda
        return lambda
      elsif opt(:onestep)
        lambda.reduce_step(@context)
      elsif opt(:reduce)
        lambda.reduce(@context, opt(:limit))
      end
    end

    def output(result)
      rst = parse_result(result) and print "<#{rst}>: "
      puts show_lambda(result)
    end


  end
end
