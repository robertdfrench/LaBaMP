module Labamp
  class Expression
    attr_accessor :type
    attr_accessor :op
    attr_reader :scope
  
    def scope=(newscope)
      @scope = newscope
      scope.expressions.pop unless scope.expressions.empty?
      scope.expressions << self
    end
   
    def method_missing(name, *args)
      raise(Error::LabampTypeError, "The type '#{@type.to_s}' does not respond to '#{name}'. Please hang up and try your call again") unless @type.respond_to? name

      op_arity = (args.length > 0) ? :binary : :unary
      if op_arity == :binary
        expr = BinaryExpression.new
        expr.right = args.first
      else
        expr = UnaryExpression.new
      end

      expr.left = self
      expr.op = name
      expr.scope = @scope
    end
  end

  class UnaryExpression < Expression
    attr_accessor :left
    
    def to_s
      left.to_s + "." + op.to_s
    end
  end

  class BinaryExpression < Expression
    attr_accessor :left
    attr_accessor :right
  
    def to_s
      left.to_s + " " + op.to_s + " " + right.to_s
    end
  end
end
