

module Sage
  class Identifier
    attr_accessor :name

    def initialize(name)
      @name = name.intern
    end

    def to_array
      @name
    end
    def to_s
      @name.to_s
    end

    def variables
      [@name]
    end
    def free_variables
      [@name]
    end

    def substitute(a, b)
      if @name == a
        return b
      else
        return self
      end
    end

    def reduce
      self
    end
    alias_method :reduce_step, :reduce

  end

end
